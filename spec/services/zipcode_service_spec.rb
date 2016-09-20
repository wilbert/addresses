require "spec_helper"

RSpec.describe ZipcodeService, type: :service do
  describe '.find', :vcr do
    context 'when pass a valid zipcode' do
      let!(:zipcode) { ZipcodeService.find('05012010') }

      it { expect(zipcode).not_to be_nil}
      it { expect(zipcode[:cidade]).to eq('São Paulo')}
      it { expect(zipcode[:bairro]).to eq('Vila Pompeia')}
      it { expect(zipcode[:logradouro]).to eq('Ministro Gastão Mesquita')}
      it { expect(zipcode[:tipo_logradouro]).to eq('Rua')}
      it { expect(zipcode[:uf]).to eq('SP')}
      it { expect(zipcode[:zipcode]).to eq('05012010')}
    end

    context 'when pass a invalid zipcode' do
      it { expect { ZipcodeService.find('99999999') }.to raise_error(ZipcodeNotFound) }
    end

    context 'when server is not avaialable' do
      before do
        allow_any_instance_of(Net::HTTPOK).to receive(:kind_of?).and_return(false)
      end
      
      it { expect { ZipcodeService.find('05012010') }.to raise_error(WebServiceNotAvaialable) }
    end
  end
end
