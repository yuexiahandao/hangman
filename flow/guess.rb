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

    puts "################################################"
    puts "Try to guess!"
    puts "result : " + word
    puts "################################################"

    word
  end
end