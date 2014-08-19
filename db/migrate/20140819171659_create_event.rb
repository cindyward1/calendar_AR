class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :description
      t.string :location
      t.datetime :start_date
      t.datetime :end_time
      t.string :repeating
      t.timestamps
    end
  end
end
