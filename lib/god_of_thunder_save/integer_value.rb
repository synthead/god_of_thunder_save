class GodOfThunderSave
  class IntegerValue
    INTEGER_DIRECTIVES = {
      1 => "C",
      2 => "v",
      4 => "V"
    }.freeze

    attr_reader :pos, :bytes

    def initialize(pos:, bytes:)
      @pos = pos
      @bytes = bytes
    end

    def read(file)
      file.seek(pos)

      bytes_read = file.read(bytes)
      bytes_read.unpack(integer_directive).first
    end

    def write(file, data)
      bytes_write = [data].pack(integer_directive)

      file.seek(pos)
      file.write(bytes_write)
    end

    private

    def integer_directive
      @integer_directive ||= INTEGER_DIRECTIVES.fetch(bytes)
    end
  end
end
