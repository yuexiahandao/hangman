require 'net/http'
require 'json'

#Flow
require File.expand_path('../flow/start_game.rb', __FILE__)
require File.expand_path('../flow/request_word.rb', __FILE__)
require File.expand_path('../flow/guess.rb', __FILE__)
require File.expand_path('../flow/get_score.rb', __FILE__)
require File.expand_path('../flow/save_score.rb', __FILE__)
#read words from file
require File.expand_path('../file_operator.rb', __FILE__)
#print logs
require File.expand_path('../log.rb', __FILE__)
#search the char to guess
require File.expand_path('../search/find_array.rb', __FILE__)


LOG.print_std_log "SESSION_ID : " + Flow::SESSION_ID.to_s
LOG.print_std_log "times to guess : " + Flow::GUESS_WORDS_NUM.to_s
LOG.print_std_log "chances to guess : " + Flow::ALLOW_WRONG_TIME.to_s
LOG.print_std_log "Words Length : " + Flow::LENGTH.to_s
LOG.print_std_log "Word to guess : " + Flow::PRIMARY_WORD.to_s


# guess
1.upto(Flow::GUESS_WORDS_NUM) do |i|
  puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  puts "The " + i.to_s + "th word to guess!"
  LOG.print_file_log "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  LOG.print_file_log "The " + i.to_s + "th word to guess!"

  #indexs = 0...Flow::LENGTH
  array = FileOperator.new(Flow::LENGTH).get_array
  1.upto(10) do |index|
    operator = ::Search::FindArray.new(array, Flow::PRIMARY_WORD, nil)
  end
end

# show user's score
Flow.get_score

# ask to save the score
print "Do you satisfied with your score? Do you want to save it?"
save_or_not = gets

if save_or_not.upcase == "YES\n" || save_or_not.upcase == "Y\n"
  Flow.do_save
end

#exit(0)
