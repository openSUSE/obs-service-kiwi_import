require 'yaml'
require './KiwiImport/lib/repository_replacer.rb'

RSpec.describe RepositoryReplacer do
  let(:repository_map) { YAML.load(File.new('./KiwiImport/config/config.yml').read)["sle_repositories"] }

  describe '#replace!' do
    context 'for a SLE kiwi config' do
      let(:input) { File.read('./spec/fixtures/sle_config_input.xml').to_s.strip }
      let!(:output) { File.read('./spec/fixtures/sle_config_output_replacer.xml').to_s.strip }
      let(:replacer) { RepositoryReplacer.new(input, repository_map) }

      it 'does replace SLE repository placeholders' do
        expect {
          replacer.replace!
        }.to change { replacer.config.strip }.from(input).to(output)
      end
    end
  end
end
