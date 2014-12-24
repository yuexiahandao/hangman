require File.expand_path('../../my_http.rb', __FILE__)

module Flow
  class StartGame

    def initialize(playerId)
      @data = "{
        \"playerId\" : \"#{playerId}\",
        \"action\" : \"startGame\"
      }"
      puts @data
    end

    def start
      response = ::MyHttp::HTTP.post(::MyHttp::URI.path, @data)
      JSON.parse(response.body)
    end

  end

  response = StartGame.new("zlcgavin@gmail.com").start

  GUESS_WORDS_NUM = response["data"]["numberOfWordsToGuess"]
  ALLOW_WRONG_TIME = response["data"]["numberOfGuessAllowedForEachWord"]
  SESSION_ID = response["sessionId"]

  puts "================================================"
  puts "Game Started!"
  puts "sessionId:" + SESSION_ID
  puts "================================================"

end