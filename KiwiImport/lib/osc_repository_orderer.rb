class OscRepositoryOrderer
  attr_accessor :config_path
  attr_reader :config

  def initialize(config_path)
    self.config_path = config_path
  end

  def order!
    result = `#{command}`
    if result.to_s.empty?
      abort("Ordering kiwi repositories failed. Command: '#{command}' failed.")
    end
    self.config = result
    config
  end

  private
  attr_writer :config

  def command
    "osc api -X POST /source?cmd=orderkiwirepos -f #{config_path}"
  end
end
