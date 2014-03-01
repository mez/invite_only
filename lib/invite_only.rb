#RAILS_3 = ::ActiveRecord::VERSION::MAJOR >= 3

require "active_record"
require "action_controller"
require "active_model"


#$LOAD_PATH.unshift(File.dirname(__FILE__))

require "invite_only/version"
require "invite_only/errors"
require "invite_only/controller_extensions"
require "invite_only/model_extensions"

#$LOAD_PATH.shift

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, InviteOnly::ModelExtensions)
  ActionController::Base.extend InviteOnly::ControllerExtensions
end

module InviteOnly
end
