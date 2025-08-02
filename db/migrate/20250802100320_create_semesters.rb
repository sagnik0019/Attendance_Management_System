class CreateSemesters < ActiveRecord::Migration[8.0]
  def change
    create_table :semesters do |t|
      t.string :name, null: false, limit: 255

      t.timestamps
    end
  end
end
