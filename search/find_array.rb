module Search
  class FindArray
    attr :match, :previous

    def initialize(array, previous, params)
      @array = array
      @previous = previous
      @match = false
      @found_chars = []
    end

    def set_indexs(result)
      @indexs = indexs
    end

    def set_pattern(params)
      @pattern = RegExp.new(params.gsub(/\*/,"."))
    end

    def find_array
      @array.reject! do |item|
        item.match(@pattern) == nil
      end
    end

    def find_char
      if @match == true
        find_array
      end
      @chars = analysis
    end

    def analysis
      hash = {}
      @array.each do |item|
        chars = item.chars.to_a - found_chars

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