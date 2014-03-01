module InviteOnly
  module ModelExtensions
    self.class_eval do
      helper_method :create_invite_code_for

      private
      #use this helper to generate the code you need to hand off to the person
      def create_invite_code_for(identifier)
        Invite.generate(identifier)
      end
    end
  end
end