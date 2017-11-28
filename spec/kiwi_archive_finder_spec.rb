require './KiwiImport/lib/kiwi_archive_finder.rb'

RSpec.describe KiwiArchiveFinder do
  describe '#archive' do
    let(:file) { 'openSUSE_42_2.kiwi.txz' }
    let(:path) { "/home/foobar" }
    let(:full_path) { "/home/foobar/#{file}" }

    context 'a directory with one kiwi archive' do
      before do
        allow(Dir).to receive(:[]).and_return([full_path])
      end

      it 'does return the kiwi archive path' do
        expect(KiwiArchiveFinder.new(path).archive).to eq(full_path)
      end
    end

    context 'a directory with more than one kiwi archive' do
      let(:another_file) { 'openSUSE_42_1.kiwi.txz' }
      let(:another_full_path) { "/home/foobar/#{another_file}" }

      before do
        allow(Dir).to receive(:[]).and_return([full_path, another_full_path])
      end

      it 'does exit the program' do
        expect {
          KiwiArchiveFinder.new(path).archive
        }.to raise_error RuntimeError
      end
    end

    context 'a directory with no kiwi archive' do
      it 'does exit the program' do
        expect {
          KiwiArchiveFinder.new(path).archive
        }.to raise_error RuntimeError
      end
    end
  end
end
