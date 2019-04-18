class CreateExercises < ActiveRecord::Migration[5.2]
  def change
    create_table :exercises do |t|
      t.integer :user_id
      t.text :description
      t.integer :duration
      t.date :date

      t.timestamps
    end
  end
end
