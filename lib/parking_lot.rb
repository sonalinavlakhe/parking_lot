require_relative './slots'
require 'pry'

class ParkingLot

  PARKING_FULL_MESSAGE = 'Sorry, parking lot is full'

  attr_accessor :slots

  def initialize(number_of_slots)
    @slots = []
    if (number_of_slots.is_a? Integer) && number_of_slots > 0
      number_of_slots.to_i.times do |index|
        slot_number = index + 1
        slots[index] = Slot.new(slot_number)
      end
      puts "Create a parking lot with #{ number_of_slots } slots"
    else
      puts "Invalid inputs to create slots"
    end
  end

  def park(vehicle_number, vehicle_color)
    if next_free_slot
      # puts "Next free slot class type #{next_free_slot.class}"
      if vehicle_already_exists?(vehicle_number)
        puts "This vehicle is already parked"
      else
        puts "Allocated slot number : #{ next_free_slot.id }"
        next_free_slot.park(vehicle_number, vehicle_color)
      end
    else
      parking_lot_full_handler
    end
  end

  def vehicle_already_exists?(vehicle_number)
    @slots.each do |slot|
      if slot.vehicle_number == vehicle_number
        return true
      end
    end
    return false
  end

  def leave(slot_number)
    slot_number = slot_number.to_i
    if slot_number > 0 && slot_number <= slots.length
      slots[slot_number - 1].free
      puts "Slot number #{ slot_number.to_i - 1 } is free "
    else
      puts "Invalid slot number"
    end
  end

  def status
    puts "Slot No.\t Registration Number\t Colour"
    slots.each do | slot |
      puts "#{ slot.id }\t\t #{ slot.vehicle_number }\t\t #{ slot.vehicle_color }" unless (slot.free?)
    end
  end

  def registration_numbers_for_cars_with_colour (color)
    filtered_cars = filter_cars('vehicle_number', 'vehicle_color', color)
    binding.pry
    if filtered_cars
      puts filtered_cars.compact.join(',')
    else
      puts "No match Found"
    end
  end

  def slot_numbers_for_cars_with_colour (color)
    filtered_cars = filter_cars('id', 'vehicle_color', color)
    if !filtered_cars.compact.empty?
      puts filtered_cars.compact.join(',')
    else
      puts "No match Found"
    end
  end

  def slot_number_for_registration_number (vehicle_number)
    slot = slots.find do |slot|
      slot.vehicle_number == vehicle_number
    end
    puts slot ? slot.id : 'Not Found'
  end

  private
    def next_free_slot
      slots.find do |slot|
        slot.free?
      end
    end

    def parking_lot_full_handler
      puts ParkingLot::PARKING_FULL_MESSAGE
    end

    def filter_cars(filtered_value, filter_by, filter)
      slots.collect do |slot|
        if slot.send(filter_by) == filter
          slot.send(filtered_value)
        end
      end
    end

    def validate_slot_number(slot_number)
      return nil
    end
end