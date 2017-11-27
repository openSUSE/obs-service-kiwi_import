require './lib/kiwi_archive.rb'

RSpec.describe KiwiArchive do
  let(:output_directory) { "./spec/tmp/output" }
  let(:input_directory) { "./spec/tmp/input" }
  let(:kiwi_archive_name) { "sles.kiwi.txz" }
  let(:kiwi_archive) { KiwiArchive.new("#{input_directory}/#{kiwi_archive_name}", output_directory) }

  before do
    FileUtils.mkdir_p(output_directory)
    FileUtils.mkdir_p(input_directory)
    FileUtils.cp("./spec/fixtures/#{kiwi_archive_name}", "#{input_directory}/#{kiwi_archive_name}")
  end

  after do
    FileUtils.rm_rf("./spec/tmp/")
  end

  describe '#create_import!' do
    before do
      kiwi_archive.create_import!
    end

    it 'renames the kiwi config' do
      expect(File.exists?("#{output_directory}/config.kiwi")).to be_truthy
    end

    it 'creates a root.tar archive' do
      expect(File.exists?("#{output_directory}/root.tar")).to be_truthy
    end
  end

  describe '#config' do
    let(:kiwi_config) { File.read("#{output_directory}/config.kiwi").to_s }

    context 'when kiwi archive is extracted' do
      before do
        kiwi_archive.create_import!
      end

      it 'returns the content of the kiwi config' do
        expect(kiwi_archive.config).to eq(kiwi_config)
      end
    end

    context 'when kiwi archive is not yet extracted' do
      it 'raises an error' do
        expect {
          kiwi_archive.config
        }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#config=' do
    context 'when kiwi archive is extracted' do
      before do
        kiwi_archive.create_import!
        kiwi_archive.config = "This is a test"
      end

      it 'writes the content of the kiwi config' do
        expect(kiwi_archive.config).to eq("This is a test")
      end
    end

    context 'when kiwi archive is not yet extracted' do
      it 'raises an error' do
        expect {
          kiwi_archive.config = "This is a test"
        }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#is_sle?' do
    context 'for a SLE config file' do
      it 'returns true' do
        allow_any_instance_of(KiwiArchive).to receive(:config).and_return('oemboot/suse-SLES12')
        expect(kiwi_archive.is_sle?).to be_truthy
      end
    end

    context 'for an openSUSE config file' do
      it 'returns true' do
        allow_any_instance_of(KiwiArchive).to receive(:config).and_return('oemboot/suse-openSUSE42')
        expect(kiwi_archive.is_sle?).to be_falsy
      end
    end
  end
end
