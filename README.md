# Rapid Transit #

## This repository is in *alpha* ##

Create a text file importer with rapid\_transit as follows:

```ruby
class WombatImporter < RapidTransit::Base

  # Set the columns in your text file
  columns :wombat_name, :favorite_food, :color, :furriness

  # Find or initialize a Wombat by name
  find_or_initialize :wombat, :name => :wombat_name

  # Find a food record that matches
  find :food, :name => :favorite_food

  # Update the wombat's attributes
  update_attributes :wombat, :color => :color, :furriness => :furriness

  # Associate the food
  exec do |row|
    row[:wombat].foods << row[:food]
  end

end
```