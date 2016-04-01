class AddIsAcceptedColumnToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :is_accepted, :boolean, default: false
  end
end
