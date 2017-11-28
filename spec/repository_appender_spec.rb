require 'yaml'
require './KiwiImport/lib/repository_appender.rb'

RSpec.describe RepositoryAppender do
  let(:repository_path) { YAML.load(File.new('./KiwiImport/config/config.yml').read)["sle_dependencies_repository"] }

  describe '#replace!' do
    context 'for a SLE kiwi config' do
      let(:input) { File.read('./spec/fixtures/sle_config_input.xml').to_s.strip }
      let!(:output) { File.read('./spec/fixtures/sle_config_output_appender.xml').to_s.strip }
      let(:appender) { RepositoryAppender.new(input, repository_path) }

      it 'does replace SLE repository placeholders' do
        expect {
          appender.append!
        }.to change { appender.config.strip }.from(input).to(output)
      end
    end
  end
end
