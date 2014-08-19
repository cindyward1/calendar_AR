require 'bundler/setup'
Bundler.require(:default, :test)

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

require "./lib/event.rb"

def welcome
  puts "\n"
  puts "*" * 40
  puts "Welcome to the Calendar application!"
  puts "*" * 40
  puts "\n"

  main_menu
end

def main_menu
  option = nil
  while option != "X"
  puts "\nThe options are:"
  puts "[ E ] = go to Events menu"
  puts "[ T ] = go to To-Do menu"
  puts "[ M ] = go to the main menu (this menu)"
  puts "[ X ] = exit the program"
  puts "\n"
  option = gets.chomp.upcase
  case option
    when "E"
     events_menu
    when "T"
     to_do_menu
    when "M"
    when "X"
      exit_program
    else
      puts "Invalid option entered, try again"
    end
  end
end

def events_menu
  option = nil
  while option != "X"
  puts "\nEvent Manager"
  puts "[ A ] = to add an event"
  puts "[ E ] = to edit and event"
  puts "[ D ] = to delete an event"
  puts "[ V ] = to view all events"
  puts "[ F ] = to find a specific event"
  puts "[ T ] = to find events in a time period"
  puts "[ M ] = go to the main menu (this menu)"
  puts "[ X ] = exit the program"
  puts "\n"
  option = gets.chomp.upcase
  case option
    when "A"
     add_event
    when "E"
     edit_event
    when "D"
      delete_event
    when "V"
      view_events
    when "F"
      find_event
    when "T"
      view_events_time_period
    when "M"
      main_menu
    when "X"
      exit_program
    else
      puts "Invalid option entered, try again"
    end
  end
end

def add_event
  puts "\n> Please enter the event name"
  description=gets.chomp
  puts "> Please enter the event location"
  location=gets.chomp
  puts "> Please enter the event start date (format 'YYYY-MM-DD')"
  start_date=gets.chomp
  puts "> Please enter the event start time"
  start_time=gets.chomp
  start_date << " " << start_time
  puts "> Please enter the event end date (format 'YYYY-MM-DD')"
  end_date=gets.chomp
  puts "> Please enter the event end time"
  end_time=gets.chomp
  end_date << " " << end_time
  puts "> Please enter 'daily' or 'weekly' or 'monthly' if this is a recurring event"
  repeating=gets.chomp
  event = Event.new({:description => description, :location=> location, :start_date => start_date,
                  :end_date=> end_date, :repeating=>repeating})
  if event.save
    puts "'#{event.description}' has been added to your Calendar"
  else
    puts "Invalid event data entered"
    event.errors.full_messages.each { |message| puts message }
  end
end

def view_events
  puts"\nThe list of all events\n"
  event_array = Event.all.order(start_date: :asc)
  event_array.each_with_index do |event, index|
    puts "#{index+1}. #{event.description} on #{event.start_date} "
  end
end

def edit_event
end

def delete_event
end

def to_do_menu
end

def exit_program
  puts "\n\nThanks for using the Calendar application! Come back again soon!\n\n"
  exit
end

welcome
