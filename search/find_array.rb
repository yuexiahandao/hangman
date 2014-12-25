module Search
  class FindArray
    attr_accessor :match, :previous, :current, :remain

    def initialize(array, previous)
      @array = array
      @previous = previous
      @match = false
      @miss_chars = []
      @used_chars =[]
      @current = previous
    end

    def set_params(word, char)
      @previous = @current
      @current = word
      add_used_chars(char)
    end

    def init_for_next_turn
      @previous = @current
      @match = true
    end

    def add_miss_chars(char)
      @miss_chars << char
    end

    def add_used_chars(char)
      @used_chars << char
    end

    def find_char
      if @match == true
        find_array
        remove_miss_match_words
        @match == false
      else
        remove_miss_match_words
      end
      #puts @array.to_s
      @chars = analysis
    end

    def guess_wrong?
      @current == @previous
    end

    def unfinished?
      @previous.match(/\*/) != nil
    end

    private

    def set_pattern
      @pattern = ::Regexp.new(current.gsub(/\*/,"."))
    end

    def remove_miss_match_words
      return if @miss_chars == []

      pattern = "["
      i = 0
      @miss_chars.each do |a|
        if i == 0
          i += 1
        else
          pattern << "|"
        end

        pattern << a.to_s
      end
      pattern << "]"

      @pattern = Regexp.new(pattern)

      @array.reject! do |item|
        item.match(@pattern) != nil
      end
    end

    def find_array
      set_pattern
      @array.reject! do |item|
        item.match(@pattern) == nil
      end
    end

    def analysis
      hash = {}
      @array.each do |item|
        chars = item.chars.to_a - @used_chars

        chars.each do |char|
          if hash[char] == nil
            hash[char] = 1
          else
            hash[char] += 1
          end
        end
      end

      hash.sort_by { |_, v| -v }
    end

  end
end