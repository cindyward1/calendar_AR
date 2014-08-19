class Event < ActiveRecord::Base
  validates :description, :presence => true
  validates_datetime :start_date
  validates_datetime :end_date

  validates :location, :presence => true
end

