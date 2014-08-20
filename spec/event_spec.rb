require 'spec_helper'
require 'event'

describe Event do
  it "ensures the user enters an event description" do
    test_event = Event.new({:description=>nil})
    expect(test_event.save).to eq false
  end

  it "ensures the user enters an event location" do
    test_event = Event.new({:location=>nil})
    expect(test_event.save).to eq false
  end

end
