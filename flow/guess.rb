module Flow
  class Guess
    def initialize(sessionId, http, char)
      @data = "{
        \"sessionId\" : \"#{sessionId}\",
        \"action\" : \"guessWord\",
        \"guess\" : \"#{char}\"
      }"
      @http = http
    end

    def guess
      response = @http.post(::MyHttp::URI.path, @data)
      JSON.parse(response.body)
    end
  end

  def self.guess_word(char)
    response = Guess.new(Flow::SESSION_ID, ::MyHttp::HTTP, char).guess
    word = response["data"]["word"]
    wrong_times = response["data"]["wrongGuessCountOfCurrentWord"]

    puts "################################################"
    puts "Try to guess!"
    puts "Guess Char : " + char.to_s
    puts "result : " + word
    puts "################################################"

    [word,wrong_times]
  end
end