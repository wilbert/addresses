require 'net/http'
require 'cgi'

# ZipcodeNotFound exception definition
class ZipcodeNotFound < StandardError
  attr_reader :zipcode

  def initialize(zipcode = nil, msg = "CEP não encontrado.")
    @zipcode = zipcode
    super(msg)
  end
end

# WebServiceNotAvaialable exception definition
class WebServiceNotAvaialable < StandardError
  def initialize(msg = "A busca de endereço por CEP através do web service da República Virtual está indisponível.")
    super(msg)
  end
end

class ZipcodeService
  WEB_SERVICE_REPUBLICA_VIRTUAL_URL = "http://cep.republicavirtual.com.br/web_cep.php?formato=query_string&cep="

  def self.find(zipcode)
    url = URI.parse("#{WEB_SERVICE_REPUBLICA_VIRTUAL_URL}#{zipcode}")
    response = Net::HTTP.get_response(url)
    raise WebServiceNotAvaialable unless response.kind_of?(Net::HTTPSuccess)

    doc = Hash[* CGI::parse(response.body).map {|k,v| [k,v[0]]}.flatten]

    zipcode_params = {}
    raise ZipcodeNotFound, zipcode unless [1,2].include?(doc['resultado'].to_i)

    %w(tipo_logradouro logradouro bairro cidade uf).each do |field|
      zipcode_params[field.to_sym] = doc[field].force_encoding("ISO-8859-1").encode("UTF-8")
    end

    zipcode_params[:zipcode] = zipcode

    zipcode_params
  end
end
