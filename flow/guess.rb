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
      begin
        response = @http.post(::MyHttp::URI.path, @data)
      rescue
        LOG.print_both "network error, try again"
        retry
      end
      
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