class SleRepositoryReplacer
  attr_accessor :config, :repository_map

  def initialize(config, repository_map)
    self.config = config
    self.repository_map = repository_map
  end

  def replace!
    replace_sle_placeholder!
    replace_repository_type!
    add_dependency_repository!
    config
  end

  private

  SLE_DEPENDENCY_REPOSITORY = <<-XML
    <!-- additional packages needed for appliance building -->
    <repository type="rpm-md">
      <source path="obs://SUSE:SLE-12-SP3:Update/OBS_Deps"/>
    </repository>
  </image>
  XML

  def replace_sle_placeholder!
    repository_map.each do |key, value|
      self.config = config.gsub(/#{key}/, value)
    end
  end

  def replace_repository_type!
    self.config = config.gsub(/<repository type=("|')yast2("|')>/, "<repository type='rpm-md'>")
  end

  def add_dependency_repository!
    self.config = config.gsub(/<\/image>/, SLE_DEPENDENCY_REPOSITORY)
  end
end
