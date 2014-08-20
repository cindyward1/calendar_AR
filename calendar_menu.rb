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
  puts "[ E ] = to edit an event"
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
      find_event(option)
    when "D"
      find_event(option)
    when "V"
      view_events
    when "F"
      find_event(option)
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
  puts "> Please enter 'daily', 'weekly', 'monthly' or 'yearly' if this is a recurring event"
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
  puts "\nWould you like to see all 'A' or only future 'F' events? (Default is future only)"
  option = gets.chomp.upcase
  if option == "A"
    puts "\nThe list of all events\n\n"
    event_array = Event.all.order(start_date: :asc)
  else
    puts "\nThe list of future events\n\n"
    today = Date.today
    event_array = Event.where("start_date >= CURRENT_DATE").order(start_date: :asc)
  end
  event_array.each_with_index do |event, index|
      puts "#{index+1}. #{event.description} on #{event.start_date} at #{event.location}"
  end
  puts "\n"
end

def find_event(option)
  puts " You can find an event using date, name, or location."
  puts "Enter 'D' to search by date, or 'N' to search by name or 'L' to search by location"
  choice=gets.chomp.upcase
  selected_events = []
  case choice
    when 'D'
      puts " Please enter a start date to search for (YYYY-MM-DD)"
      date=gets.chomp
      if date =~ /\d\d\d\d-\d\d-\d\d/
        selected_events = Event.where("TO_CHAR(start_date,'YYYY-MM-DD') LIKE '#{date}%'")
      end
    when 'N'
      puts " Please enter the event name to search for"
      description=gets.chomp
      selected_events = Event.where(description: description)
    when 'L'
      puts " Please enter the event location to search for"
      location=gets.chomp
      selected_events = Event.where(location: location)
  end
  if selected_events.empty?
    puts "No events were found with your selection criteria"
  else
    puts "Here is a list of your selected events"
    selected_events.each_with_index do |event, index|
      puts "#{index+1}. #{event.description} on #{event.start_date} until #{event.end_date} at #{event.location}"
    end
    if option == "D"
      delete_event(selected_events)
    elsif option == "E"
      edit_event(selected_events)
    elsif option == "F"
      puts "Would you like to edit ('E') or delete ('D') an event? Enter any other key to skip"
      new_option = gets.chomp
      if new_option == "D"
        delete_event(selected_events)
      elsif new_option == "E"
        edit_event(selected_events)
      end
    end
  end
end

def edit_event(selected_events)
  puts" \nPlease enter the index of the event you'd like to edit"
  event_index = gets.chomp.to_i
  if event_index == 0 || event_index > selected_events.length
    puts "Invalid index, please try again"
  else
    event = selected_events[event_index-1]
    update_hash = Hash.new
    puts" \nPlease review each field and enter any changes"
    puts" Event Name: #{event.description}"
    puts" New name:"
    new_description = ""
    new_description=gets.chomp
    if new_description != ""
      update_hash[:description] = new_description
    end

    puts" Location: #{event.location}"
    puts" New Location:"
    new_location = ""
    new_location=gets.chomp
    if new_location != ""
      update_hash[:location] = new_location
    end

    event_start_date = event.start_date.strftime('%F')
    puts" Start Date: #{event_start_date}"
    puts" New Start Date: "
    new_start_date = ""
    new_start_date=gets.chomp

    event_start_time = event.start_date.strftime('%H:%M')
    puts" Start Time: #{event_start_time}"
    puts" New Start time: "
    new_start_time = ""
    new_start_time=gets.chomp
    if new_start_date != "" && new_start_date =~ /\d\d\d\d-\d\d-\d\d/ && new_start_time != ""
      new_start_date = "TO_DATE(" + new_start_date + " " + new_start_time + ")"
      update_hash[:start_date] = new_start_date
    elsif new_start_date != "" && new_start_date =~ /\d\d\d\d-\d\d-\d\d/
      new_start_date = "TO_DATE(" + new_start_date + " " + event_start_time + ")"
      update_hash[:start_date] = new_start_date
    elsif new_start_time != ""
      new_start_date = "TO_DATE(" + event_start_date + " " + new_start_time + ")"
      update_hash[:start_date] = new_start_date
    end

    event_end_date = event.end_date.strftime('%F')
    puts" End Date: #{event_end_date}"
    puts" New End Date: "
    new_end_date = ""
    new_end_date=gets.chomp

    event_end_time = event.end_date.strftime('%H:%M')
    puts" End Time: #{event_end_time}"
    puts" New End Time: "
    new_end_time = ""
    new_end_time=gets.chomp
    if new_end_date != "" && new_end_date =~ /\d\d\d\d-\d\d-\d\d/ && new_end_time != ""
      new_end_date = "TO_DATE(" + new_end_date + " " + new_end_time + ")"
      update_hash[:end_date] = new_end_date
    elsif new_end_date != "" && new_end_date =~ /\d\d\d\d-\d\d-\d\d/
      new_end_date = "TO_DATE(" + new_end_date + " " + event_end_time + ")"
      update_hash[:end_date] = new_end_date
    elsif new_end_time != ""
      new_end_date = "TO_DATE(" + event_end_date + " " + new_end_time + ")"
      update_hash[:end_date] = new_end_date
    end

  end
  event.update(update_hash)
  puts "The event #{event.description} has been updated."
end

def delete_event(selected_events)
  puts" \nPlease enter the index of the event you'd like to delete"
  event_index = gets.chomp.to_i
  if event_index == 0 || event_index > selected_events.length
    puts "Invalid index #{event_index}, please try again"
  else
    event = selected_events[event_index-1]
    puts "Do you REALLY want to delete this event? This action cannot be undone!"
    puts "Enter 'Y' or 'YES' to delete, any other key to skip"
    answer = gets.chomp.upcase.slice(0,1)
    if answer == "Y"
      puts "#{event.description} on #{event.start_date} at #{event.location} has been deleted"
      event.destroy;
    end
  end
end

def to_do_menu
end

def exit_program
  puts "\n\nThanks for using the Calendar application! Come back again soon!\n\n"
  exit
end

welcome
