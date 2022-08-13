class GodOfThunderSave
  ENTRIES = {
    jewels: 0x65
  }.freeze

  attr_reader :path
  ENTRIES.keys.each { |entry| attr_accessor entry }

  def initialize(path)
    @path = path

    set_accessors
  end

  def save!
    File.open(path, File::RDWR) do |file|
      ENTRIES.each do |entry, pos|
        memory_value = instance_variable_get(:"@#{entry}")
        self.class.write_bytes(file, pos, memory_value)
      end
    end

    self
  end

  private

  def set_accessors
    File.open(path) do |file|
      ENTRIES.each do |entry, pos|
        file_value = self.class.read_bytes(file, pos)
        instance_variable_set(:"@#{entry}", file_value)
      end
    end
  end

  def self.read_bytes(file, pos)
    file.seek(pos)

    byte_array = file.read(2)
    byte_array.unpack("v").first
  end

  def self.write_bytes(file, pos, data)
    data_bytes = [data].pack("v")

    file.seek(pos)
    file.write(data_bytes)
  end
end
