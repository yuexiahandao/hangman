module Flow
  class SaveScore
    def initialize(sessionId, http)
      @data = "{
        \"sessionId\" : \"#{sessionId}\",
        \"action\" : \"submitResult\"
      }"
      @http = http
    end

    def save
      response = @http.post(::MyHttp::URI.path, @data)
      JSON.parse(response.body)
    end
  end

  def self.do_save
    response = SaveScore.new(Flow::SESSION_ID, ::MyHttp::HTTP).score
    puts response
    puts "================================================"
    puts "Save User's Score Done"
    puts "================================================"
  end
end