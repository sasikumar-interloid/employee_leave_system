class CreateLeaveTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_types do |t|
      t.string :name, null: false
      t.references :created_by, foreign_key: {to_table: :users}

      t.timestamps
    end

    add_index :leave_types, :name, unique: true
  end
end
