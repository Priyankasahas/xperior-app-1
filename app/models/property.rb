class Property < ActiveRecord::Base
  %w[building_name address].each do |attr|
    validates attr, presence: true
  end

  def self.property_by_id(id)
    find_by(id: id)
  end

  def self.property_by_building_name(name)
    find_by(building_name: name)
  end
end
