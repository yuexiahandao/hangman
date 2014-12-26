require 'net/http'

class MyHttp

  uri = URI.parse("your request url")

  HTTP = Net::HTTP.new(uri.host, uri.port)
  URI = uri

end
