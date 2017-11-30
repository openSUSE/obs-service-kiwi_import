require './KiwiImport/lib/http_repository_orderer.rb'
require 'webmock/rspec'

RSpec.describe HttpRepositoryOrderer do
  describe '#order!' do
    let(:api_url) { 'https://api.opensuse.org' }
    let(:full_path) { "#{api_url}/source?cmd=orderkiwirepos" }
    let(:orderer) { HttpRepositoryOrderer.new('foo', api_url, {}) }

    context 'with an error' do
      before do
        stub_request(:post, full_path).with(body: 'foo').to_return(status: 404, body: 'bar', headers: { Location: 'https://example.com/' } )
      end

      it 'does not change the config' do
        expect {
          orderer.order!
        }.to raise_error(RuntimeError)
      end
    end

    context 'with a successful request' do
      before do
        stub_request(:post, full_path).with(body: 'foo').to_return(status: 200, body: 'bar', headers: {})
        orderer.order!
      end

      it 'saves the updated config' do
        expect(orderer.config).to eq('bar')
      end
    end

    context 'with a redirect' do
      before do
        stub_request(:post, full_path).with(body: 'foo').to_return(status: 301, body: '', headers: { Location: 'https://example.com/' } )
        stub_request(:post, full_path).with(body: 'foo').to_return(status: 200, body: 'bar', headers: {})
        orderer.order!
      end

      it 'follows the redirect and saves the updated config' do
        expect(orderer.config).to eq('bar')
      end
    end
  end
end
