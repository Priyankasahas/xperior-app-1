class UpdatesProperties
  Result = Struct.new(:success?, :errors, :property)

  def self.update!(property_id, attrs = {})
    property = Property.property_by_id(property_id)

    return Result.new(false, errors: ['Property is not found']) unless property.present?

    Result.new(property.update_attributes(attrs), property.try(:errors).try(:messages),
               property)
  end
end
