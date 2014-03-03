module InviteOnly
  module ControllerExtensions

    #use this method to enable invite only helper method in your controllers/views
    def enable_invite_only
      self.class_eval do
        helper_method :create_invite_code_for

        protected
        #use this helper to generate the code you need to hand off to the person
        #identifier can be anything that IDs the person i.e. Email|Username etc...
        #identifier: type=string
        def create_invite_code_for(identifier)
          #if email has been invited before, just update with new code.
          invite = Invite.find_or_initialize_by identifier:identifier
          #code is only valid for the identifier provided and can only be used once.
          invite.is_used=false
          invite.code=SecureRandom.urlsafe_base64
          invite.save! #no need to validate
          return invite.code
        end
      end
    end

  end
end