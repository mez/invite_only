module InviteOnly
  class Error < StandardError
  end

  module Errors
    class NotRespondingToInviteCode < InviteOnly::Error
    end

    class NotRespondingToIdentifier < InviteOnly::Error
    end

  end
end