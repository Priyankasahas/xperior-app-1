require 'spec_helper'
require 'creates_properties'

RSpec.describe CreatesProperties do
  context 'create!' do
    let(:building_name) { 'ANZ Bank' }
    let(:address) { '123 City Road, Melbourne' }

    let(:property_model) { class_double('Property').as_stubbed_const }
    let(:property) { double(:property) }

    before do
      allow(property_model).to receive(:new) { property }
    end

    let(:attrs) do
      { building_name: building_name, address: address }
    end

    subject { CreatesProperties.create!(attrs) }

    context 'given valid property data' do
      before do
        expect(property).to receive(:save) { true }
        expect(property).to receive(:errors) { double(messages: []) }
      end

      it 'should indicate a successful creation' do
        expect(subject).to be_success
      end

      it 'should return no errors' do
        expect(subject.errors).not_to be_present
      end

      it 'should return access to the created property' do
        expect(subject.property).to eq property
      end
    end

    context 'given invalid property data' do
      let(:message) { 'content' }

      before do
        expect(property).to receive(:save) { false }
        expect(property).to receive(:errors) { double(messages: message) }
      end

      it 'should indicate an unsuccessful creation' do
        expect(subject).not_to be_success
      end

      it 'should return errors' do
        expect(subject.errors).to be_present
      end

      it 'should return access to the errored property' do
        expect(subject.property).to eq property
      end
    end
  end
end
