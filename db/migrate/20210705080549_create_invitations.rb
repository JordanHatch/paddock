class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
