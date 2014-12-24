require 'net/http'

class MyHttp

  uri = URI.parse("http://strikingly-hangman.herokuapp.com/game/on")

  HTTP = Net::HTTP.new(uri.host, uri.port)
  URI = uri

end