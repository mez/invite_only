module InviteOnly

  module ModelExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def invite_only(identifier = :email, options={})

        #on create make sure invite code is good
        #validate :invite_code_legit?, on: :create

        validate Proc.new {|m|
          #first check we have the attributes we need
          # You need to have an identifier default='email' and an 'invite_code' either as virtual attributes or columns
          # in this model!
          raise InviteOnly::Errors::NotRespondingToIdentifier unless m.respond_to? identifier.to_sym
          raise InviteOnly::Errors::NotRespondingToInviteCode unless m.respond_to? :invite_code

          #make sure it is not blank
          if m.invite_code.blank?
            errors.add(:invite_code, m.code_blank_message)
            return
          end

          #make sure it is an existing code.
          invite = Invite.find_by_code m.invite_code
          if invite.nil?
            errors.add(:invite_code, m.code_invalid_message)
            return
          end
          #make sure it matches the identifier invite.
          if invite.identifier != m.send(identifier.to_sym)
            errors.add(:invite_code, m.code_identifier_invalid_message)
            return
          end

          if invite.is_used
            errors.add(:invite_code, m.code_already_used_message)
            return
          end
        }, :on => :create

        #if all checks out, be sure to invalidated code. Use Once Policy
        after_create {
          #look up the invite recode with the invite_code and mark it used.
          invite = Invite.find_by_code self.invite_code
          invite.is_used = true
          invite.save!
        }

        private
        #these are private scoped attributes used for the invite messages in validation
        attr_writer :code_blank_message,
                  :code_invalid_message,
                  :code_identifier_invalid_message,
                  :code_already_used_message

        #set the reader for the message validations if not set
        define_method :code_blank_message do
          @code_blank_message ||= "is missing."
        end

        define_method :code_identifier_invalid_message do
          @code_identifier_invalid_message ||= "does not work with that #{identifier.to_s}."
        end

        define_method :code_invalid_message do
          @code_invalid_message ||= "is not valid."
        end

        define_method :code_already_used_message do
          @code_already_used_message ||= "has already been used."
        end

      end

    end
  end
end