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
