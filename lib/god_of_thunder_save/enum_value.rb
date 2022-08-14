# frozen_string_literal: true

class GodOfThunderSave
  class EnumValue
    attr_reader :pos, :enums

    def initialize(pos:, enums:)
      @pos = pos
      @enums = enums
    end

    def read(file)
      file.seek(pos)
      index = file.readchar

      enums.invert.fetch(index)
    end

    def write(file, enum_key)
      index = enums.fetch(enum_key)

      file.seek(pos)
      file.write(index)
    end
  end
end
