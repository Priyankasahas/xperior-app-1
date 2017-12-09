class CreatesProperties
  Result = Struct.new(:success?, :errors, :property)

  def self.create!(attrs = {})
    property = Property.new(
      building_name: attrs[:building_name],
      address: attrs[:address]
    )

    property_created = property.save

    Result.new(property_created, property.errors.messages, property)
  end
end
