class SleRepositoryReplacer
  attr_accessor :config

  def initialize(config)
    self.config = config
  end

  def replace!
    if is_sle?
      replace_sle_placeholder!
      replace_repository_type!
      add_dependency_repository!
    end
    config
  end

  private

  def is_sle?
    # There is no better way to determine if it is a SLE image description
    # than testing for the boot attribute
    config.include?('oemboot/suse-SLES12')
  end

  # For now we map all SLE12 repositories to the SLE12 SP3 repositories
  # as we don't plan to support SP0 and SP1
  REPOSITORY_MAP = {
    "{SLES 12 SP3 Updates x86_64}" => "obs://SUSE:SLE-12-SP3:Update/SLES",
    "{SLES 12 SP3 x86_64}" => "obs://SUSE:SLE-12-SP3:GA/SLES",
    "{SLE 12 SP3 SDK x86_64}" => "obs://SUSE:SLE-12-SP3:GA/SDK",
    "{SLE 12 SP3 SDK Updates x86_64}" => "obs://SUSE:SLE-12-SP3:Update/SDK",
    "{SLES 12 SP1 Updates x86_64}" => "obs://SUSE:SLE-12-SP3:Update/SLES",
    "{SLES 12 SP1 x86_64}" => "obs://SUSE:SLE-12-SP3:GA/SLES",
    "{SLE 12 SP1 SDK x86_64}" => "obs://SUSE:SLE-12-SP3:GA/SDK",
    "{SLE 12 SP1 SDK Updates x86_64}" => "obs://SUSE:SLE-12-SP3:Update/SDK",
    "{SLES 12 Updates x86_64}" => "obs://SUSE:SLE-12-SP3:Update/SLES",
    "{SLES 12 x86_64}" => "obs://SUSE:SLE-12-SP3:GA/SLES",
    "{SLE 12 SDK x86_64}" => "obs://SUSE:SLE-12-SP3:GA/SDK",
    "{SLE 12 SDK Updates x86_64}" => "obs://SUSE:SLE-12-SP3:Update/SDK",
  }

  SLE_DEPENDENCY_REPOSITORY = <<-XML
    <!-- additional packages needed for appliance building -->
    <repository type="rpm-md">
      <source path="obs://SUSE:SLE-12-SP3:Update/OBS_Deps"/>
    </repository>
  </image>
  XML

  def replace_sle_placeholder!
    REPOSITORY_MAP.each do |key, value|
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
