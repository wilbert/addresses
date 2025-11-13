# frozen_string_literal: true

module Addresses
  module CountrySeedData
    COUNTRIES = [
      { name: "United States", iso2: "US", iso3: "USA", capital: "Washington D.C.", currency: "USD", phone_code: "+1" },
      { name: "Canada", iso2: "CA", iso3: "CAN", capital: "Ottawa", currency: "CAD", phone_code: "+1" },
      { name: "United Kingdom", iso2: "GB", iso3: "GBR", capital: "London", currency: "GBP", phone_code: "+44" },
      { name: "Germany", iso2: "DE", iso3: "DEU", capital: "Berlin", currency: "EUR", phone_code: "+49" },
      { name: "France", iso2: "FR", iso3: "FRA", capital: "Paris", currency: "EUR", phone_code: "+33" },
      { name: "Japan", iso2: "JP", iso3: "JPN", capital: "Tokyo", currency: "JPY", phone_code: "+81" },
      { name: "Australia", iso2: "AU", iso3: "AUS", capital: "Canberra", currency: "AUD", phone_code: "+61" },
      { name: "Brazil", iso2: "BR", iso3: "BRA", capital: "Brasília", currency: "BRL", phone_code: "+55" },
      { name: "India", iso2: "IN", iso3: "IND", capital: "New Delhi", currency: "INR", phone_code: "+91" },
      { name: "China", iso2: "CN", iso3: "CHN", capital: "Beijing", currency: "CNY", phone_code: "+86" },
      { name: "Mexico", iso2: "MX", iso3: "MEX", capital: "Mexico City", currency: "MXN", phone_code: "+52" },
      { name: "Russia", iso2: "RU", iso3: "RUS", capital: "Moscow", currency: "RUB", phone_code: "+7" },
      { name: "South Africa", iso2: "ZA", iso3: "ZAF", capital: "Cape Town", currency: "ZAR", phone_code: "+27" },
      { name: "Argentina", iso2: "AR", iso3: "ARG", capital: "Buenos Aires", currency: "ARS", phone_code: "+54" },
      { name: "Egypt", iso2: "EG", iso3: "EGY", capital: "Cairo", currency: "EGP", phone_code: "+20" },
      { name: "Turkey", iso2: "TR", iso3: "TUR", capital: "Ankara", currency: "TRY", phone_code: "+90" },
      { name: "Indonesia", iso2: "ID", iso3: "IDN", capital: "Jakarta", currency: "IDR", phone_code: "+62" },
      { name: "Thailand", iso2: "TH", iso3: "THA", capital: "Bangkok", currency: "THB", phone_code: "+66" },
      { name: "South Korea", iso2: "KR", iso3: "KOR", capital: "Seoul", currency: "KRW", phone_code: "+82" },
      { name: "Spain", iso2: "ES", iso3: "ESP", capital: "Madrid", currency: "EUR", phone_code: "+34" }
    ].freeze
    
    def self.countries_data
      COUNTRIES
    end
    
    def self.sample_countries(n = 5)
      COUNTRIES.sample(n)
    end
  end
end