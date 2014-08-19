class AlterEventTypo < ActiveRecord::Migration
  def change
    remove_column :events, :end_time
    add_column :events, :end_date, :string
  end
end
