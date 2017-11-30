class KiwiArchiveFinder
  attr_accessor :path

  def initialize(path = Dir.pwd)
    self.path = path
  end

  def archive
    kiwi_archive = Dir[File.join(path, '/*.kiwi.txz')]
    if kiwi_archive.length > 1
      raise 'More than one kiwi archives found'
    elsif kiwi_archive.length == 0
      raise 'No kiwi archive found'
    end
    kiwi_archive[0]
  end
end
