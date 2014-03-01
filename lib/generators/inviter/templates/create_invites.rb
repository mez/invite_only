class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :identifier
      t.string :code
      t.boolean :is_used, default: false

      t.timestamps
    end
  end
end