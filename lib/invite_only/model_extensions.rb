module InviteOnly
  module ModelExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def invite_only(identifier = :email, options={})

        #first check we have the attributes we need
        # You need to have an identifier default='email' and an 'invite_code' either as virtual attributes or columns
        # in this model!
        raise InviteOnly::Errors::NotRespondingToIdentifier unless self.respond_to? identifier.to_sym
        raise InviteOnly::Errors::NotRespondingToInviteCode unless self.respond_to? :invite_code

        #grab the valid options if you want different messages then defaults.
        valid_options = options.slice(
            :code_blank_message,
            :code_invalid_message,
            :code_identifier_invalid_message,
            :code_already_used_message
          )

        #these are private scooped attributes used for messages in validation
        self.code_invalid_message=valid_options[:code_blank_message] ||= "is missing."
        self.code_identifier_invalid_message = valid_options[:code_identifier_invalid_message] ||= "does not work with that #{identifier.to_s}."
        self.code_invalid_message= valid_options[:code_invalid_message] ||= "is not valid."
        self.code_already_used_message= valid_options[:code_already_used_message] ||= "has already been used."

        #on create make sure invite code is good
        validate :invite_code_legit?, on: :create
        #if all checks out, be sure to invalidated code. Use Once Policy
        after_create :invite_code_used
      end


      private

      #give message attributes private scope goodness
      attr_accessor :code_blank_message,
                :code_invalid_message,
                :code_identifier_invalid_message,
                :code_already_used_message


      #check if invite is legit
      def invite_code_legit?
        #make sure it is not blank
        if self.invite_code.blank?
          errors.add(:invite_code, self.code_blank_message)
          return
        end

        #make sure it is an existing code.
        invite = Invite.find_by_code self.invite_code
        if invite.nil?
          errors.add(:invite_code, self.code_invalid_message)
          return
        end
        #make sure it matches the identifier invite.
        if invite.identifier != self.send(identifier.to_sym)
          errors.add(:invite_code, self.code_identifier_invalid_message)
          return
        end

        if invite.is_used
          errors.add(:invite_code, self.code_already_used_message)
          return
        end
      end

      def invite_code_used
        #look up the invite recode with the invite_code and mark it used.
        invite = Invite.find_by_code self.invite_code
        invite.is_used = true
        invite.save(false)
      end
    end
  end
end