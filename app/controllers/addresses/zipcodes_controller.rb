# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class ZipcodesController < ApplicationController
    def show
      @zipcode = Zipcode.find_by(number: params[:zipcode])

      if @zipcode.present?
        city = @zipcode.city
        state = city.state
        neighborhood = @zipcode.neighborhood

        states = State.all.order(:name).map { |s| { id: s.id, name: s.name, acronym: s.acronym } }
        cities = state.cities.order(:name).map { |c| { id: c.id, name: c.name } }
        neighborhoods = city.neighborhoods.order(:name).map { |n| { id: n.id, name: n.name } }

        render json: {
          zipcode: @zipcode,
          states: states,
          selected_state_id: state.id,
          cities: cities,
          selected_city_id: city.id,
          neighborhoods: neighborhoods,
          selected_neighborhood_id: neighborhood&.id
        }
      else
        render json: { errors: :zipcode_not_found }, success: false, status: :unprocessable_entity
      end
    end
  end
end
