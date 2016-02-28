class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :username
      t.integer :role
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end

    add_index :users, :uid, unique: true
  end
end
