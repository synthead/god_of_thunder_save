# God of Thunder saved game editor for Ruby

Edit your God of Thunder saved games with Ruby!

<img src="https://user-images.githubusercontent.com/820984/184477829-9023eca6-fa72-4683-9fbf-f8ec7418bed4.png" width="640px">

## Usage

Load a saved game file, edit it to your liking, and write the changes!

```ruby
require "god_of_thunder_save"

save = GodOfThunderSave.new("SAVEGAM1.GOT")

save.name = "My renamed game"
save.keys = 5
save.jewels = 500
save.wind_power = true

save.write!
```

`#attributes` will also return everything the library knows about:

```ruby
save.attributes

{:name=>"god_of_thunder_save",
 :health=>145,
 :magic=>130,
 :item=>:enchanted_apple,
 :jewels=>420,
 :keys=>69,
 :score=>31337,
 :enchanted_apple=>true,
 :lightning_power=>true,
 :winged_boots=>false,
 :wind_power=>false,
 :amulet_of_protection=>false,
 :thunder_power=>false}
```

Every key in this list has a getter and a setter, like in the code example above.

This library only reads and writes data indicated by the library, so your position, progress, etc. will remain intact.

**Don't forget to make a backup first!**

## Development

So you want to contribute!  Great!  Here are some resources to get started!

### Adding a new setter and getter

All setters and getters are defined in the `ENTRIES` Hash here:

https://github.com/synthead/god_of_thunder_save/blob/928491d785321b5e65b25066ac98bc96e1c73ee9/lib/god_of_thunder_save.rb#L8-L21

The keys define the setter and getter methods, and the value classes handle reading and writing the data.

If you're looking to add support for a new attribute, it may only be necessary to add a new key/value pair and utilize one of the existing value classes.

### Adding a new value class

If you need to add a new class to support a new value type, create a new file in [`lib/god_of_thunder_save/`](/lib/god_of_thunder_save/), and start with something like this:

```ruby
class GodOfThunderSave
  class NewValue
    attr_reader :pos, :bytes

    def initialize(pos:, bytes:)
      @pos = pos
      @bytes = bytes
    end

    def read(file)
      file.seek(pos)
      file.read(bytes)
    end

    def write(file, value)
      file.seek(pos)
      file.write(value)
    end
  end
end
```

Add a key/value pair of the new attribute and instance of your class to `ENTRIES` Hash, and you're good to go!

Whenever `GodOfThunderSave#read!` is called, `#read` will be called on your class with the save game as a `File` instance.  When `GodOfThunderSave#write!` is called, `#write` will be called with a `File` instance opened in read/write mode, and the data to write.

Each value class is responsible for ensuring that data is read and written correctly, and can safely handle values that could possibly be incorrect or out-of-range for the save game data.

### Writing tests

Any new feature should include tests.  They are written in RSpec and live in [`spec/`](/spec/).

For write tests, a real `GodOfThunderSave` instance is created on real save game data, data is written by the instance, and the save game data is then tested itself.  The tests make use of the excellent [FakeFS](https://github.com/fakefs/fakefs) library to mock files, so the fixture data is never modified when tests are performed.

To ensure that we're only altering the save game data we expect, the write tests always inspect the entire file for changes.  The `save_game_data_changed` subject will return a Hash of file positions and their changed values, which is used in every test:

https://github.com/synthead/god_of_thunder_save/blob/d68a8dea1f4446c7b31c368a5f97dbb7ace927ed/spec/lib/god_of_thunder_save_spec.rb#L143-L153

Here is an example of a test for writing data:

https://github.com/synthead/god_of_thunder_save/blob/d68a8dea1f4446c7b31c368a5f97dbb7ace927ed/spec/lib/god_of_thunder_save_spec.rb#L304-L311

For read tests, the getter methods are used to ensure that the library can correctly parse the save game data:

https://github.com/synthead/god_of_thunder_save/blob/d68a8dea1f4446c7b31c368a5f97dbb7ace927ed/spec/lib/god_of_thunder_save_spec.rb#L104-L108

### Running tests

To run the entire test suite, call `rspec` with `bundle`:

```shell
bundle exec rspec --format=documentation
```
