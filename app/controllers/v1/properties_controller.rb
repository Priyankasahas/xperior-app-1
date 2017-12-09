require 'creates_properties'
require 'updates_properties'

module V1
  class PropertiesController < PrivateController
    def index
      render json: Property.all
    end

    def show
      property = Property.property_by_id(params[:id])

      if property
        render json: property
      else
        head :not_found
      end
    end

    def create
      create = CreatesProperties.create!(create_params)

      if create.success?
        render json: create.property, status: :created
      else
        render json: create.errors, status: :bad_request
      end
    end

    def update
      update = UpdatesProperties.update!(params[:id], update_params)

      if update.success?
        render json: update.property
      else
        render json: update.errors, status: :bad_request
      end
    end

    def destroy
      s = Property.find_by(id: params[:id])
      if s.present?
        s.destroy
        render json: { success: true }
      else
        render json: { success: false, error: "Property not found with #{params[:id]}" }, status: :not_found
      end
    end

    private

    def create_params
      params.require(:property).permit(:building_name, :address)
    end

    def update_params
      params.require(:property).permit(:building_name, :address)
    end
  end
end
