require './KiwiImport/lib/osc_repository_orderer.rb'

RSpec.describe OscRepositoryOrderer do
  describe '#order!' do
    let(:orderer) { OscRepositoryOrderer.new('./spec/fixtures/sle_config_input.xml') }

    before do
      allow(orderer).to receive(:`).with("osc api -X POST /source?cmd=orderkiwirepos -f ./spec/fixtures/sle_config_input.xml").and_return("foo")
      orderer.order!
    end

    it 'saves the updated config' do
      expect(orderer.config).to eq('foo')
    end
  end
end
