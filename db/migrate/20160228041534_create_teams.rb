class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :slug
      t.string :repository
      t.belongs_to :course

      t.timestamps null: false
    end

    create_table :student_teams, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true
    end
  end
end
