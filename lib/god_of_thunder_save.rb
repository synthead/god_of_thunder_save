require "god_of_thunder_save/integer_value"
require "god_of_thunder_save/string_value"

class GodOfThunderSave
  ENTRIES = {
    name: StringValue.new(pos: 0, length: 22),
    health: IntegerValue.new(pos: 0x63, bytes: 2),
    jewels: IntegerValue.new(pos: 0x65, bytes: 2),
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
