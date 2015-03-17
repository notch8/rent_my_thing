module RentMyThing
  def gather_map_attributes attributes
    map_attributes = {}
    attributes.each do |pin_type, locations|
      [*locations].each do |location|
        if location.coords
          map_attributes[pin_type] ||= []
          map_attributes[pin_type].push({address: location.address, coords: [location.coords[0], location.coords[1]], highlight: "posting_#{location.id}"})
        end
      end
    end
    map_attributes.to_json
  end
  module_function :gather_map_attributes
end
