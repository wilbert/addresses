require 'net/http'
require 'json'

module Addresses
  class CepService < OpenStruct
    URL='http://cep.republicavirtual.com.br/web_cep.php?formato=json'
    MASK = "%{tipo_logradouro} %{logradouro}, %{bairro}"
    MASK_FULL = "%{tipo_logradouro} %{logradouro}, %{bairro} - %{cidade}/%{uf}"

    attr_accessor :attr

    def initialize(cep_or_attr)
      if cep_or_attr.is_a? Hash
        @attr = cep_or_attr
      else
        @attr = self.class.find(cep_or_attr)
      end

      super @attr
      self.send('resultado=', self.resultado.to_i)
      
      @attr = @attr.symbolize_keys rescue nil
    end

    def attr
      @attr ||= self.to_h
    end

    def address_full
      if valid?
        MASK_FULL % attr
      else
        ''
      end
    end

    def address
      if valid?
        MASK % attr 
      else
        ''
      end
    end

    def valid?
      resultado>=1
    end

    def to_json
      self.attr.merge(address_full: address_full, address:address).to_json
    end

    def self.find(cep)
      uri = URI(URL+"&cep=#{cep}")
      puts "::GET #{uri}"
      response = Net::HTTP.get(uri)
      params = JSON.parse(response)
      CepService.new params
    end
  end
end