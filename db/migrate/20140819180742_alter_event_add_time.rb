class AlterEventAddTime < ActiveRecord::Migration
  def change
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
    remove_column :events, :start_date
    remove_column :events, :end_date
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
  end
end
