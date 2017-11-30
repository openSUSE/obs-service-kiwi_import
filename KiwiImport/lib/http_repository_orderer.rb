require 'net/https'

class HttpRepositoryOrderer
  attr_accessor :config, :api_url, :options

  def initialize(config, api_url, options = {})
    self.config = config
    self.api_url = api_url
    self.options = options
  end

  def order!
    order_via_http!
    config
  end

  private

  def order_via_http!
    limit = 5
    response = send_order_request(api_url)

    while response.kind_of?(Net::HTTPRedirection) && limit > 0
      response = send_order_request(response['location'])
      limit -= 1
    end

    unless response.kind_of?(Net::HTTPSuccess)
      raise "Ordering kiwi repositories failed. Backend responded with '#{response.code} - #{response.message}'"
    end
    self.config = response.body
  end

  def send_order_request(url)
    uri = URI.parse(url)

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = (uri.scheme == "https")
    https.set_debug_output($stdout) if options[:verbose]

    request = Net::HTTP::Post.new("/source?cmd=orderkiwirepos")
    request.body = config
    request.content_type = "text/xml"

    https.request(request)
  end
end
