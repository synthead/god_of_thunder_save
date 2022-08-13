require "god_of_thunder_save/bitmask_value"
require "god_of_thunder_save/integer_value"
require "god_of_thunder_save/string_value"

class GodOfThunderSave
  ENTRIES = {
    name: StringValue.new(pos: 0, length: 22),
    health: IntegerValue.new(pos: 0x63, bytes: 1),
    magic: IntegerValue.new(pos: 0x64, bytes: 1),
    jewels: IntegerValue.new(pos: 0x65, bytes: 2),
    keys: IntegerValue.new(pos: 0x67, bytes: 1),
    enchanted_apple: BitmaskValue.new(pos: 0x69, bitmask: 0x01),
    lightning_power: BitmaskValue.new(pos: 0x69, bitmask: 0x02),
    winged_boots: BitmaskValue.new(pos: 0x69, bitmask: 0x04),
    wind_power: BitmaskValue.new(pos: 0x69, bitmask: 0x08),
    amulet_of_protection: BitmaskValue.new(pos: 0x69, bitmask: 0x10),
    thunder_power: BitmaskValue.new(pos: 0x69, bitmask: 0x20),
    score: IntegerValue.new(pos: 0x70, bytes: 4)
  }.freeze

  attr_reader :path
  ENTRIES.keys.each { |entry| attr_accessor entry }

  def initialize(path)
    @path = path

    set_accessors
  end

  def save!
    File.open(path, File::RDWR) do |file|
      ENTRIES.each do |entry_name, entry|
        memory_value = instance_variable_get(:"@#{entry_name}")
        entry.write(file, memory_value)
      end
    end

    self
  end

  private

  def set_accessors
    File.open(path) do |file|
      ENTRIES.each do |entry_name, entry|
        file_value = entry.read(file)
        instance_variable_set(:"@#{entry_name}", file_value)
      end
    end
  end
end
