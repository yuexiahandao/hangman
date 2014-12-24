class FileOperator

  def initialize(n)
    @len = n
    file_name
  end

  def file_name
    @name = "word_data/word-#{@len}.txt"
  end

  def get_array
    a = []
    if File.exist?(@name)
      file = File.open(@name,"r") do |file|
        while line=file.gets
          a << line.chomp if line!="\n"
        end
      end
    else
      exit(1) unless File.exist?("words.txt")
      
      file = File.open(@name,"w") do |file|
        file2 = File.open("words.txt","r") do |f|
          while line=f.gets

            if line.nil?
              next
            else
              line = line.chomp.upcase
            end

            if line.length == @len
              a << line
              file.puts line
            end
          end
        end

        #file2.close
      end
    end

    #file.close
    a
  end

end