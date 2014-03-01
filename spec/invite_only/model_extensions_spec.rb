require 'spec_helper'

#let's setup a test db
ActiveRecord::Schema.define(:version => 1) do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.column :email, :string
  end

  create_table :accounts, :force => true do |t|
    t.column :username, :string
  end

  create_table :invites, :force => true do |t|
    t.column :is_used, :boolean, default: false
    t.column :code, :string
    t.column :identifier, :string
  end

end

# Setup the models
class User < ActiveRecord::Base
  attr_accessor :invite_code
  invite_only(:email)
end

class Account < ActiveRecord::Base
  attr_accessor :invite_code
  invite_only(:username)
end

class Invite < ActiveRecord::Base
end

#let test a few things
describe InviteOnly do

  #let make sure when new invite record is created is_used=false
  describe 'Creating a new Invite means it is not used yet' do
    before { @invite = Invite.new }
    it { @invite.is_used.should == false }
  end


  describe 'User and Account Should Be Valid on Save with correct Code and Identifier' do
    before do
      Invite.create! code:'usercode', identifier:'user@example.com'
      Invite.create! code:'accountcode', identifier:'2chanz'
    end

    it "creates user when correct code and identifier is used" do
      User.create(email:'user@example.com', invite_code:'usercode').should be_valid
    end

    it "creates account when correct code and identifier is used" do
      Account.create(username:'2chanz', invite_code:'accountcode').should be_valid
    end
  end

  describe 'Invite Not Valid on Create with Correct Code but different Identifier' do
    before do
      @invite_account = Invite.create code:'accountcode', identifier:'2pac'
    end

    #sorry 2chanz but this invite was for 2pac.
    it { Account.create(username:'2chanz', invite_code:'accountcode').should_not be_valid }
  end

  describe 'Invite Not Valid on Create with Different Code but Correct Identifier' do
    before do
      @invite_account = Invite.create code:'bangbang', identifier:'chiefkeef'
    end

    #sorry 2pac but you have wrong invite code
    it { Account.create(username:'chiefkeef', invite_code:'notbangbang').should_not be_valid }
  end


  describe 'Invite can only be used once' do
    before do
      @invite_account = Invite.create code:'kimk', identifier:'yeezus'
    end

    #sorry 2chanz but this invite was for 2pac.
    it do
      #yeezus should be good to go
      Account.create(username:'yeezus', invite_code:'kimk').should be_valid
      #not so fast ray j
      Account.create(username:'ray-j', invite_code:'kimk').should_not be_valid
    end
  end


end

