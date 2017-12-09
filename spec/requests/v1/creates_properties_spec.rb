require 'rails_helper'

RSpec.describe 'create property endpoint' do
  let(:building_name) { 'ANZ Bank' }
  let(:address) { '123 Main Road, Melbourne' }

  context 'given valid property data' do
    before do
      authenticated_post properties_path, property: { building_name: building_name,
                                                      address: address }
    end

    it 'should return a created status' do
      expect(response).to have_http_status(:created)
    end

    context 'created property' do
      subject { Property.property_by_building_name(building_name) }

      it 'should have the specified building name' do
        expect(subject.building_name).to eq building_name
      end

      it 'should have specified address' do
        expect(subject.address).to eq address
      end
    end
  end

  context 'given invalid property data with building_name and address being nil' do
    before do
      authenticated_post properties_path, property: { building_name: nil, address: nil }
    end

    it 'should indicate a bad request' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'should include the missing handler error' do
      expect(json_body).to eq 'building_name' => ["can't be blank"],
                              'address' => ["can't be blank"]
    end
  end

  context 'given an unauthenticated request' do
    before do
      post properties_path
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
