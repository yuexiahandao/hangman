require 'net/http'
require 'json'

#print logs
require File.expand_path('../log.rb', __FILE__)
#Flow
require File.expand_path('../flow/start_game.rb', __FILE__)
require File.expand_path('../flow/request_word.rb', __FILE__)
require File.expand_path('../flow/guess.rb', __FILE__)
require File.expand_path('../flow/get_score.rb', __FILE__)
require File.expand_path('../flow/save_score.rb', __FILE__)
#read words from file
require File.expand_path('../file_operator.rb', __FILE__)
#search the char to guess
require File.expand_path('../search/find_array.rb', __FILE__)

LOG.print_file_log "**********************************"
LOG.print_file_log "**          Welcome             **"
LOG.print_file_log "**********************************"


LOG.print_both "SESSION_ID : " + Flow::SESSION_ID.to_s
LOG.print_both "times to guess : " + Flow::GUESS_WORDS_NUM.to_s
LOG.print_both "chances to guess : " + Flow::ALLOW_WRONG_TIME.to_s


# guess
1.upto(Flow::GUESS_WORDS_NUM) do |i|
  puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  puts "The " + i.to_s + "th word to guess!"
  LOG.print_file_log "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  LOG.print_file_log "The " + i.to_s + "th word to guess!"

  #indexs = 0...Flow::LENGTH
  length, primary_word = Flow.get_word
  LOG.print_both "Words Length : " + length.to_s
  LOG.print_both "Word to guess : " + primary_word.to_s

  array = FileOperator.new(length).get_array
  #LOG.print_file_log array.to_s

  operator = ::Search::FindArray.new(array, primary_word)
  
  catch(:exit) {
    while operator.unfinished?
      chars = operator.find_char

      LOG.print_file_log chars.to_s

      if chars.nil? || chars[0].nil?
        LOG.print_both "Sorry the word is not in word list! Please add it!"
        LOG.print_both "failed to guess this word!"
        LOG.print_both "last match is #{operator.current}"
        throw :exit
      end

      char = chars[0][0]
      word, wrong_times = Flow.guess_word(char)

      LOG.print_both "guess result world: #{word}"
      LOG.print_both "guess char: #{char}"
      LOG.print_both "guess wrong_times : #{wrong_times}"

      operator.set_params(word, char)

      if wrong_times >= 10
        puts "failed to guess this word!Last match is #{operator.current}"
        LOG.print_file_log "failed to guess this word!Last match is #{operator.current}"
        throw :exit
      end

      if operator.guess_wrong?
        operator.add_miss_chars(char)
      else
        operator.init_for_next_turn
      end

    end

    puts "Finished Guess! The word is #{operator.current}"
    LOG.print_file_log "Finished Guess! The word is #{operator.current}"
  }

  #puts chars[0][0],"==="
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
