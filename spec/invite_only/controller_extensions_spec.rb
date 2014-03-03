require 'spec_helper'

class User < ActiveRecord::Base
  invite_only(:email)
  attr_accessor :invite_code
end

class RoxburyController < ActionController::Base
  include Rails.application.routes.url_helpers
  enable_invite_only
end

describe RoxburyController, type: :controller do

  context 'when call the create_invite_code_for' do
    controller do
      def index
        code = create_invite_code_for "Doug.Butabi"
        render text:'Doug Butabi is finally making it into a club.'
      end
    end

    it 'should be available as a method' do
      expect { get :index }.not_to raise_error
    end
  end
end