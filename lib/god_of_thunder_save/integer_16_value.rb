class GodOfThunderSave
  class Integer16Value
    attr_reader :pos

    def initialize(pos:)
      @pos = pos
    end

    def read(file)
      file.seek(pos)

      bytes = file.read(2)
      bytes.unpack("v").first
    end

    def write(file, data)
      bytes = [data].pack("v")

      file.seek(pos)
      file.write(bytes)
    end
  end
end
