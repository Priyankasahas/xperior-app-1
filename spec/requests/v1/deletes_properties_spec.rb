require 'rails_helper'

RSpec.describe 'delete property endpoint' do
  let(:building_name) { 'ANZ Bank' }

  context 'given valid property data' do
    before do
      property = create(:property, building_name: building_name)
      authenticated_delete property_path(property.id)
    end

    it 'should delete property' do
      expect(Property.property_by_building_name(building_name)).to be_nil
    end
  end

  context 'given invalid property data' do
    before do
      authenticated_delete property_path(11111)
    end

    it 'should return not found' do
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'given an unauthenticated request' do
    before do
      property = create(:property)
      delete property_path(property.id)
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
