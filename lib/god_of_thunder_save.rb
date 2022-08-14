# frozen_string_literal: true

require "god_of_thunder_save/bitmask_value"
require "god_of_thunder_save/enum_value"
require "god_of_thunder_save/integer_value"
require "god_of_thunder_save/string_value"
require "god_of_thunder_save/version"

class GodOfThunderSave
  ITEM_ENUMS = {
    nil => "\x00",
    :enchanted_apple => "\x01",
    :lightning_power => "\x02",
    :winged_boots => "\x03",
    :wind_power => "\x04",
    :amulet_of_protection => "\x05",
    :thunder_power => "\x06"
  }.freeze

  ENTRIES = {
    name: StringValue.new(pos: 0x00, length: 22),
    health: IntegerValue.new(pos: 0x63, bytes: 1),
    magic: IntegerValue.new(pos: 0x64, bytes: 1),
    item: EnumValue.new(pos: 0x68, enums: ITEM_ENUMS),
    jewels: IntegerValue.new(pos: 0x65, bytes: 2),
    keys: IntegerValue.new(pos: 0x67, bytes: 1),
    score: IntegerValue.new(pos: 0x70, bytes: 4),
    enchanted_apple: BitmaskValue.new(pos: 0x69, bitmask: 0x01),
    lightning_power: BitmaskValue.new(pos: 0x69, bitmask: 0x02),
    winged_boots: BitmaskValue.new(pos: 0x69, bitmask: 0x04),
    wind_power: BitmaskValue.new(pos: 0x69, bitmask: 0x08),
    amulet_of_protection: BitmaskValue.new(pos: 0x69, bitmask: 0x10),
    thunder_power: BitmaskValue.new(pos: 0x69, bitmask: 0x20)
  }.freeze

  attr_reader :path
  ENTRIES.keys.each { |entry| attr_accessor entry }

  def initialize(path)
    @path = path

    read!
  end

  def attributes
    ENTRIES.keys.to_h do |entry_name|
      [entry_name, instance_variable_get(:"@#{entry_name}")]
    end
  end

  def read!
    File.open(path) do |file|
      ENTRIES.each do |entry_name, entry|
        file_value = entry.read(file)
        instance_variable_set(:"@#{entry_name}", file_value)
      end
    end

    self
  end

  def write!
    File.open(path, File::RDWR) do |file|
      ENTRIES.each do |entry_name, entry|
        memory_value = instance_variable_get(:"@#{entry_name}")
        entry.write(file, memory_value)
      end
    end

    self
  end
end
