class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :user_role
      t.string :email
      t.references :course, index: true, foreign_key: true
      t.integer :sender_id, index: true, foreign_key: true
      t.integer :recipient_id, foreign_key: true
      t.string :token

      t.timestamps null: false
    end

    add_index :invites, [:course_id, :sender_id, :email], unique: true
  end
end
