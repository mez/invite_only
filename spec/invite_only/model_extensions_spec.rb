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

  protected
  def code_blank_message
    'code is blank'
  end
end

class Invite < ActiveRecord::Base
end

#let test a few things
describe InviteOnly do

  describe 'model_extension' do
    context 'when a new invite is created' do
      let(:invite) { Invite.new }
      it { expect(invite.is_used).to be false }
    end

    context 'when validating a model that used invite only' do
      before do
        Invite.create! code:'usercode', identifier:'user@example.com'
        Invite.create! code:'2chanzcode', identifier:'2chanz'
        Invite.create code:'2paccode', identifier:'2pac'
        Invite.create code:'bangbang', identifier:'chiefkeef'
        Invite.create code:'kimk', identifier:'yeezus'
      end


      it 'should use the identifier used to init invite_only' do
        expect(User.create(email:'user@example.com', invite_code:'usercode')).to be_valid
        expect(Account.create(username:'2chanz', invite_code:'2chanzcode')).to be_valid
      end

      it 'should not validate with correct invite_code but different identifier' do
        #sorry 2chanz but this invite was for 2pac.
        expect(Account.create(username:'2chanz', invite_code:'2paccode')).not_to be_valid
      end

      it 'should not validate with different invite_code but correct identifier' do
        #sorry chiefkeef but you have wrong invite code
        expect(Account.create(username:'chiefkeef', invite_code:'notbangbang')).not_to be_valid
      end

      it 'should only used once.' do
        #yeezus should be good to go
        expect(Account.create(username:'yeezus', invite_code:'kimk')).to be_valid
         #not so fast ray j
        expect(Account.create(username:'ray-j', invite_code:'kimk')).not_to be_valid
      end

      it 'should have errors when not valid' do
        expect(Account.create(username:'foo', invite_code:'bar').errors.count).to eq(1)
      end

      it 'should show the correct error message on blank invite_code' do
        #[:invite_code, ["code is blank"]] is the error message format
        expect(Account.create(username:'chiefkeef', invite_code:'').errors.messages.first.last.first).to eq('code is blank')
      end

      it 'should set is_used to true after create' do
        Account.create(username:'yeezus', invite_code:'kimk')
        expect(Invite.find_by(code:'kimk').is_used).to be true
      end
    end
  end
end

