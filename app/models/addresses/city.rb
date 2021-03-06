# frozen_string_literal: true

module Addresses
  class City < ActiveRecord::Base
    belongs_to :state

    default_scope { order('name asc') }

    has_many :neighborhoods
    has_many :zipcodes

    validates :name, :state_id, presence: true

    class << self
      def filter(params = {})
        return [] if params[:state_id].blank? && params[:name].blank?

        cities = City.order('name asc')

        cities = cities.where('state_id = ?', params[:state_id]) if params[:state_id]
        cities = cities.where("name #{query_word} ?", "#{params[:name]}%") if params[:name]

        cities
      end

      private
        def query_word
          adapter == 'postgresql' ? 'ilike' : 'like'
        end

        def adapter
          ActiveRecord::Base.connection.instance_values['config'][:adapter]
        rescue
          nil
        end
    end
  end
end
