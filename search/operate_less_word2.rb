module Search
  class OperateLessWord
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
      if @remain > 1
        find_main_char
      else
        @chars
      end
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

    def find_main_char
      LOG.print_file_log @chars.to_s

      len = @chars.length - 1

      result = {}

      0.upto(len) do |i|
        array = remove_miss_char_words(@chars[i][0])
        hash = pre_analysis(array)

        values = hash.sort_by { |_, v| -v }
        #puts values
        keys = values.map{|v| v[0]}

        result[i] = keys.length*@remain
        length = keys.length - 1

        judge = 0

        length.downto(1) do |s|
          a = values[s][0]
          pattern = Regexp.new "#{a}"
          times = find_times(array,pattern)
          result[i] - times
        end

        length.downto(0) do |s|
          keys.each do |k|
            break if judge > 0
            a = values[s][0]
            #puts a
            pattern = Regexp.new "#{a}.*#{k}|#{k}.*#{a}"
            times = find_times(array,pattern)
            judge = 1 if times > 0

            if times==hash[values[s][0]]
              result[i] -= 1
            end
          end
        end
      end

      sp = result.sort_by{|_,v| v }

      LOG.print_file_log result.to_s
      LOG.print_file_log sp.to_s

      return @chars if (sp.nil? || sp[0].nil?)
      return @chars if result[0] == sp[0][0]

      [[@chars[sp[0][0]][0],1]]
    end

    def remove_miss_char_words(char)
      pattern = Regexp.new("[#{char}]")

      array = @array.reject do |item|
        item.match(pattern) != nil
      end
    end

    def pre_analysis(array)
      hash = {}
      array.each do |item|
        chars = item.chars.to_a - @used_chars

        chars.each do |char|
          if hash[char] == nil
            hash[char] = 1
          else
            hash[char] += 1
          end
        end
      end
      hash
    end

    def find_times(array, pattern)
      times = 0
      array.each do |s|
        times+=1 if s.match(pattern)!=nil
      end
      times
    end

  end
end