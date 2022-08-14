# frozen_string_literal: true

class GodOfThunderSave
  class BitmaskValue
    attr_reader :pos, :bitmask

    def initialize(pos:, bitmask:)
      @pos = pos
      @bitmask = bitmask
    end

    def read(file)
      file.seek(pos)
      byte = file.readbyte

      byte & bitmask > 0
    end

    def write(file, data)
      file.seek(pos)
      byte = file.readbyte

      byte &= inverted_bitmask
      byte += bitmask if data
      byte = byte.chr

      file.seek(pos)
      file.write(byte)
    end

    def inverted_bitmask
      @inverted_bitmask ||= bitmask ^ 0xff
    end
  end
end
