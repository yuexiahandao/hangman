module Flow
  class RequestWord
    def initialize(sessionId, http)
      @data = "{
        \"sessionId\" : \"#{sessionId}\",
        \"action\" : \"nextWord\"
      }"
      @http = http
    end

    def next_word
      response = @http.post(::MyHttp::URI.path, @data)
      JSON.parse(response.body)
    end
  end

  response = RequestWord.new(Flow::SESSION_ID, ::MyHttp::HTTP).next_word
  PRIMARY_WORD = response["data"]["word"]
  LENGTH = response["data"]["word"].length

  puts "++++++++++++++++++++++++++++++++++++++++++++++++"
  puts "Get a word!"
  puts "length: " + LENGTH.to_s
  puts "++++++++++++++++++++++++++++++++++++++++++++++++"

end