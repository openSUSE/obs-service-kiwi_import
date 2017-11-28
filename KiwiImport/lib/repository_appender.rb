class RepositoryAppender
  attr_accessor :config, :repository_path

  def initialize(config, repository_path)
    self.config = config
    self.repository_path = repository_path
  end

  def append!
    self.config = config.gsub(/<\/image>/, repository)
    config
  end

  private

  def repository
    <<-XML
      <!-- additional packages needed for appliance building -->
      <repository type="rpm-md">
        <source path="#{repository_path}"/>
      </repository>
    </image>
    XML
  end
end
