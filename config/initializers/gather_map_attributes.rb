module RentMyThing
  def gather_map_attributes attributes
    map_attributes = {}
    attributes.each do |pin_type, locations|
      [*locations].each do |location|
        if location.coords
          map_attributes[pin_type] ||= []
          map_attributes[pin_type].push [location.address, [location.coords[0], location.coords[1]]]
        end
      end
    end
    map_attributes.to_json
  end
  module_function :gather_map_attributes
end
