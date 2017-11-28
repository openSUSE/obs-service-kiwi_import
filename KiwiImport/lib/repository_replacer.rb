class RepositoryReplacer
  attr_accessor :config, :repository_map

  def initialize(config, repository_map)
    self.config = config
    self.repository_map = repository_map
  end

  def replace!
    replace_sle_placeholder!
    replace_repository_type!
    config
  end

  private

  def replace_sle_placeholder!
    repository_map.each do |key, value|
      self.config = config.gsub(/#{key}/, value)
    end
  end

  def replace_repository_type!
    self.config = config.gsub(/<repository type=("|')yast2("|')>/, "<repository type='rpm-md'>")
  end
end
