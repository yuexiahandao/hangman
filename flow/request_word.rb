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

  def self.get_word
    response = RequestWord.new(Flow::SESSION_ID, ::MyHttp::HTTP).next_word
    primary_word = response["data"]["word"]
    length = response["data"]["word"].length

    puts "++++++++++++++++++++++++++++++++++++++++++++++++"
    puts "Get a word!"
    puts "length: " + length.to_s
    puts "++++++++++++++++++++++++++++++++++++++++++++++++"

    [length, primary_word]
  end

end