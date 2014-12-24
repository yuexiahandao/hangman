module Flow
  class GetScore
    def initialize(sessionId, http)
      @data = "{
        \"sessionId\" : \"#{sessionId}\",
        \"action\" : \"getResult\"
      }"
      @http = http
    end

    def score
      response = @http.post(::MyHttp::URI.path, @data)
      JSON.parse(response.body)
    end
  end

  def self.get_score
    response = GetScore.new(::Flow::SESSION_ID, ::MyHttp::HTTP).score

    puts "================================================"
    puts "Get User's Score"
    puts "Score:" + response["data"]["score"].to_s
    puts "================================================"

    response
  end

end