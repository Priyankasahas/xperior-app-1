require 'rails_helper'

RSpec.describe Property do
  let(:property) { create(:property) }

  context 'validations' do
    context 'invalid' do
      context 'blank name' do
        subject do
          property.building_name = new_name
          property
        end

        [nil, ''].each do |new_name|
          let(:new_name) { new_name }

          it 'should be invalid and have errors messages' do
            expect(subject.valid?).to be false
            expect(subject.errors.full_messages).to include "Building name can't be blank"
          end
        end

        context 'blank address' do
          subject do
            property.address = new_address
            property
          end

          [nil, ''].each do |new_address|
            let(:new_address) { new_address }

            it 'should be invalid and have errors messages' do
              expect(subject.valid?).to be false
              expect(subject.errors.full_messages).to include "Address can't be blank"
            end
          end
        end
      end
    end
  end

  context '.property_by_building_name' do
    context 'when the property exists' do
      it 'should return the property' do
        property = create(:property)
        expect(Property.property_by_building_name(property.building_name)).to eq property
      end
    end

    context 'when the property does not exist' do
      it 'should return nil' do
        expect(Property.property_by_building_name('ANZ Bank')).to eq nil
      end
    end
  end

  context '.property_by_id' do
    context 'when the property exists' do
      it 'should return the property' do
        property = create(:property)
        expect(Property.property_by_id(property.id)).to eq property
      end
    end

    context 'when the property does not exist' do
      it 'should return nil' do
        expect(Property.property_by_id(1)).to eq nil
      end
    end
  end
end
