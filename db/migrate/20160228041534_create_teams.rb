class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :slug
      t.string :repository
      t.belongs_to :course, index: true

      t.timestamps null: false
    end

    create_table :teams_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true
    end

    add_index :teams_users, [:user_id, :team_id], unique: true
  end
end
