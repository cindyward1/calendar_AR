class AltereventBackagain < ActiveRecord::Migration

  def change

    remove_column :events, :start_time
    remove_column :events, :start_date
    remove_column :events, :end_time
    remove_column :events, :end_date

    add_column :events, :start_date, :datetime
    add_column :events, :end_date, :datetime
  end
end
