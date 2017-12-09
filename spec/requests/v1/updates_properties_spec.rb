require 'rails_helper'

RSpec.describe 'update property endpoint' do
  let(:building_name) { 'ANZ Bank' }
  let(:address) { '123 Main Road, Melbourne' }

  context 'given valid property data' do
    before do
      property = create(:property, building_name: building_name, address: address)
      authenticated_put property_path(property.id), property: { building_name: 'CommonWealth Bank' }
    end

    it 'should update property' do
      expect(Property.first.building_name).to eq('CommonWealth Bank')
    end
  end

  context 'given invalid property data' do
    before do
      authenticated_put property_path(11111), property: { building_name: 'CommonWealth Bank' }
    end

    it 'should return not found' do
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'given an unauthenticated request' do
    before do
      property = create(:property)
      put property_path(property.id)
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
