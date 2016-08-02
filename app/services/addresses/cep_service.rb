require 'net/http'
require 'json'

module Addresses
  class CepService < OpenStruct
    URL='http://cep.republicavirtual.com.br/web_cep.php?formato=json'
    MASK = "%{tipo_logradouro} %{logradouro}, %{bairro}"
    MASK_FULL = "%{tipo_logradouro} %{logradouro}, %{bairro} - %{cidade}/%{uf}"

    attr_accessor :attr

    def initialize(cep)
      @attr = self.class.find(cep)
      super @attr
      self.send('resultado=', self.resultado.to_i)
      
      @attr = @attr.symbolize_keys rescue nil

      # {
      #   resultado:'1'
      #   resultado_txt:'sucesso - cep completo'
      #   uf:'SP'
      #   cidade:'São Paulo'
      #   bairro:'Vila Barbosa'
      #   tipo_logradouro:'Rua'
      #   logradouro:'Professor João Leocádio'
      # }
    end

    def address_full
      MASK_FULL % @attr
    end

    def address
      MASK % @attr
    end

    def valid?
      resultado>=1
    end

    def self.find(cep)
      uri = URI(URL+"&cep=#{cep}")
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end
  end
end

