class AddPresentFieldToAttendance < ActiveRecord::Migration[8.0]
  def change
    add_column :attendances, :present, :boolean, null: true

  end
end
