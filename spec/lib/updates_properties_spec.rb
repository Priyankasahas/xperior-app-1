require 'spec_helper'
require 'updates_properties'

RSpec.describe UpdatesProperties do
  context 'update!' do
    let(:property_id) { 1 }
    let(:attrs) do
      { building_name: 'ANZ Bank',
        address: '123 Main Street, Melbourne' }
    end

    let(:property_model) { class_double('Property').as_stubbed_const }
    let(:property) { double(:property) }

    subject { UpdatesProperties.update!(property_id, attrs) }

    context 'given invalid property data' do
      before do
        expect(property_model).to receive(:property_by_id).and_return(property)
        expect(property).to receive(:update_attributes).with(attrs).and_return(false)
      end

      it 'should indicate an unsuccessful update' do
        expect(subject.success?).to be false
      end

      it 'should return access to the errored property' do
        expect(subject.property).to eq property
      end
    end

    context 'given valid property data' do
      before do
        expect(property_model).to receive(:property_by_id).and_return(property)
        expect(property).to receive(:update_attributes).with(attrs).and_return(true)
      end

      it 'should indicate a successfull update' do
        expect(subject.success?).to be true
      end

      it 'should return access to the updated property' do
        expect(subject.property).to eq property
      end
    end
  end
end
