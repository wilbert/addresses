require 'spec_helper'

module Addresses
  describe CepService, :vcr do
    describe '.find' do
      let(:cep){ '02556180' }
      # let(:result_json){
      #   {resultado:'1', resultado_txt:'sucesso - cep completo', uf:'SP', cidade:'São Paulo', bairro:'Vila Barbosa', tipo_logradouro:'Rua', logradouro:'Professor João Leocádio'}
      # }

      subject { described_class.find(cep) }
      it { expect(subject).to be_kind_of(Addresses::CepService) }
    end

    describe '.new' do
      let(:cep){ '02556180' }
      subject { described_class.new(cep) }

      it { expect(subject).to be_kind_of(Addresses::CepService) }
    end

    describe '#valid?' do
      let(:cep){ '02556180' }
      let(:cep_service){ described_class.new(cep) }
      subject { cep_service.valid? }

      it { expect(subject).to be(true) }
    end

    describe '#address' do
      let(:cep){ '02556180' }
      let(:cep_service){ described_class.new(cep) }
      subject { cep_service.address }

      it { expect(subject).to eq("Rua Professor João Leocádio, Vila Barbosa") }
    end

    describe '#address_full' do
      let(:cep){ '02556180' }
      let(:cep_service){ described_class.new(cep) }
      subject { cep_service.address_full }

      it { expect(subject).to eq("Rua Professor João Leocádio, Vila Barbosa - São Paulo/SP") }
    end
  end
end