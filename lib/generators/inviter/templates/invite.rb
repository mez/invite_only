class Invite < ActiveRecord::Base

  #generates the code for the ID and returns the code.
  def self.generate(identifier)
    #if email has been invited before, just update with new code.
    invite = Invite.find_or_initialize_by identifier:identifier
    #code is only valid for the identifier provided and can only be used once.
    #default -> invite.is_used=false
    invite.code=SecureRandom.urlsafe_base64
    invite.save! #no need to validate
    return invite.code
  end

end