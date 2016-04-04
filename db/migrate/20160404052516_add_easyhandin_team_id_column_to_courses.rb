class AddEasyhandinTeamIdColumnToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :easyhandin_team_id, :integer
  end
end
