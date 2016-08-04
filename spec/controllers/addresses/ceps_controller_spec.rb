require 'spec_helper'

module Addresses
  describe CepsController, type: :controller do
    routes { Addresses::Engine.routes }
    
    let(:cep){'02556180'}
    let(:cep_unknown){'0000000'}

    describe "GET 'show'", :vcr do
      context 'when valid' do
        before { 
          get :show, { id: cep } 
          @json = JSON.parse(response.body)
        }

        it "returns http success" do
          response.should be_success
        end
        it { assigns(:cep_service).should be_kind_of(Addresses::CepService) }
        it { assigns(:cep_service).should be_valid }
        it { @json['address'].should == "Rua Professor João Leocádio, Vila Barbosa" }
      end

      context 'when invalid' do
        before { 
          get :show, { id: cep_unknown } 
          @json = JSON.parse(response.body)
        }

        it 'returns http success' do
          response.should be_success
        end

        it { assigns(:cep_service).should be_kind_of(Addresses::CepService) }
        it { assigns(:cep_service).should_not be_valid }
        it { @json['resultado'].should == "0" }
      end

    end
  end
end

# {"resultado"=>"1",
#  "resultado_txt"=>"sucesso - cep completo",
#  "uf"=>"SP",
#  "cidade"=>"São Paulo",
#  "bairro"=>"Vila Barbosa",
#  "tipo_logradouro"=>"Rua",
#  "logradouro"=>"Professor João Leocádio",
#  "address_full"=>"Rua Professor João Leocádio, Vila Barbosa - São Paulo/SP",
#  "address"=>"Rua Professor João Leocádio, Vila Barbosa"}
