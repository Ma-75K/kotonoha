class CreateRecordings < ActiveRecord::Migration[8.0]
  def change
    create_table :recordings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :child, null: false, foreign_key: true
      t.string :title
      t.text :comment
      t.datetime :recorded_at, null: false
      t.integer :duration, null: false

      t.timestamps
    end
    add_index :recordings, :recorded_at
  end
end
