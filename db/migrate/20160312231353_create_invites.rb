class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :user_role
      t.string :email
      t.string :university_id
      t.belongs_to :course, index: true
      t.belongs_to :sender, index: true
      t.belongs_to :recipient, index: true
      t.string :token

      t.timestamps null: false
    end

    add_index :invites, [:course_id, :sender_id, :email], unique: true
  end
end
