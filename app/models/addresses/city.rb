# frozen_string_literal: true

module Addresses
  class City < ActiveRecord::Base
    validates :name, :state_id, presence: true

    belongs_to :state

    has_many :neighborhoods

    def self.filter(params = {})
      query_word = 'like'

      query_word = 'ilike' if adapter == 'postgresql'

      cities = City.order('name asc')

      cities = cities.where("name #{query_word} ?", "%#{params[:name]}%") if params[:name]

      cities
    end

    private
      def self.adapter
        ActiveRecord::Base.connection.instance_values['config'][:adapter]
      rescue
        nil
      end
  end
end
