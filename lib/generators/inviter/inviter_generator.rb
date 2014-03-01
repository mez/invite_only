class InviterGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  extend Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)


  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S%6N")
  end

    #need to create the Invite table. Start out only supporting activerecord
  def setup_active_record_for_invite_only
    template "invite.rb", "app/models/invite.rb"
    migration_template "create_invites.rb", "db/migrate/create_invites.rb"
    rake 'db:migrate'
  end

end
