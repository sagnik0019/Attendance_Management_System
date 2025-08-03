class AdjustFieldLimits < ActiveRecord::Migration[8.0]
  def change
    change_column :departments, :code, :string, limit: 3
    change_column :subjects, :code, :string, limit: 6
  end
end
