module Search
  class OperateLessWord2
    attr_accessor :match, :previous, :current, :remain

    def initialize(array, previous)
      @array = array
      @previous = previous
      @match = false
      @miss_chars = []
      @used_chars =[]
      @current = previous
    end

    # every guess, rest some params
    def set_params(word, char)
      @previous = @current
      @current = word
      add_used_chars(char)
    end

    # if guess successfully, reset some params for next turn guess
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

    # find the siutable char to guess
    def find_char
      if @match == true
        find_array
        remove_miss_match_words
        @match == false
      else
        remove_miss_match_words
      end

      @chars = analysis

      #for short words do
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

    # find match conditions' array
    def find_array
      set_pattern
      @array.reject! do |item|
        item.match(@pattern) == nil
      end
    end

    # count each char's times and sort
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

    # for short words
    # if the char guess failed, can it remove more steps?
    def find_main_char
      LOG.print_file_log @chars.to_s

      len = @chars.length - 1
      total = @array.length

      result = {}

      0.upto(len) do |i|
        break if (@chars[0][1]-@chars[i][1]) > (total*0.15).to_i
        array = remove_miss_char_words(@chars[i][0])
        hash = pre_analysis(array)

        values = hash.sort_by { |_, v| -v }
        #puts values
        keys = values.map{|v| v[0]}

        result[i] = keys.length*(@remain-1)

        length = keys.length - 1

        judge = 0

        length.downto(1) do |s|
          a = values[s][0]
          times = find_times(array, a, keys)
          result[i] = result[i] - times
        end

      end

      sp = result.sort_by{|_,v| v }

      LOG.print_file_log result.to_s
      LOG.print_file_log sp.to_s

      return @chars if (sp.nil? || sp[0].nil?)
      #return @chars if result[0] == sp[0][0]

      char = sp[0]
      sp.each do |val|
        unless val.nil?
          if val[1] == char[1] && val[0] < char[0]
            char = val
          end
        end 
      end

      [[@chars[char[0]][0],1]]
    end

    # Assuming that the char guess failed
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

    # find the char can be removed in n steps 
    # from condition without guess it
    def find_times(array, char, keys)
      keys = keys - [char]
      array_length = array.length
      times = 0

      catch(:exit) {
        1.upto(@remain-1) do |i|
          char_combines = get_relative_chars(keys, i)

          #throw :exit if char_combines.length > 1000
          throw :exit if char_combines.length > 2600

          char_combines.each do |combine|
            pattern = form_regexp(combine, char)
            puts pattern
            result = true
            array.each do |item|
              if item.match(pattern).nil?
                result = false
                break
              end
            end

            if result
              times = @remain - i
              throw :exit 
            end
          end
        end
      }

      puts times
      times

    end

    # Get character permutations
    def get_relative_chars(keys, n)
      return keys if(n == 1)
      
      array = []

      keys.each do |char|
        b = n-1
        temp = get_relative_chars(keys-[char], b)
        temp.map! { |e| e + "|" +char }
        array += temp
      end

      array
    end

    def form_regexp(str, char)
      not_str = "["+ str +"]"
      # the words length is changeless
      pattern = not_str + "+.*" + char + "|" + char + ".*" +not_str + "+"

      Regexp.new(pattern)

    end

  end
end