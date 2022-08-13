class GodOfThunderSave
  class StringValue
    attr_reader :pos, :length

    def initialize(pos:, length:)
      @pos = pos
      @length = length
    end

    def read(file)
      file.seek(pos)
      string = file.read(length)

      string.strip
    end

    def write(file, string)
      formatted_string = pad_and_truncate(string)

      file.seek(pos)
      file.write(formatted_string)
    end

    private

    def pad_and_truncate(string)
      string[0..length - 1].ljust(length, "\0")
    end
  end
end
