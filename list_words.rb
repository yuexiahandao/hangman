## This file is used to clear the same words

content = []

file = File.open("words.txt","r") do |file|
  while line=file.gets
    content << line.chomp.strip.downcase if line!="\n"
  end
end

distinct = []
content.each do |s|
  distinct << s if distinct.index(s) == nil
end

File.open("words-new.txt","w") do |file|
  distinct.each do |s|
    file.puts s
  end
end