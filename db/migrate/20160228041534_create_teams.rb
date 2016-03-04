class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :slug
      t.string :repository
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :student_teams, id: false do |t|
      t.references :user, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
    end

    add_index :student_teams, [:user_id, :team_id], unique: true
  end
end
