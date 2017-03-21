require 'open-uri'
require 'json'

class WordGameController < ApplicationController

  def game
    @grid = generate_grid(9).join
  end

  def score
    @guess = params[:guess]
    @grid = params[:grid].split("")
    @start_time = 10
    @end_time = 20
    @answer_hash = run_game(@guess, @grid, @start_time, @end_time)
  end




# Logic for ganme This should e in the model really

def translator(attempt)
  key = 'e0908b6d-8da4-4cc6-b7de-c2062ecce54a'
  url = "https://api-platform.systran.net/translation/text/translate?input=#{attempt}&source=en&target=fr&withSource=false&withAnnotations=false&backTranslation=false&encoding=utf-8&key=#{key}
"
  trans_return = open(url).read
  trans_json = JSON.parse(trans_return)
  trans = trans_json['outputs'][0]['output']
  trans
end

def timer(start_time, end_time)
  (end_time - start_time).to_f
end

def check_in_grid(attempt, grid)
  attempt.upcase!
  att_arr = attempt.split("")
  bool = true
  att_arr.each do |letter|
    # puts letter
    if grid.include?(letter)
      grid.delete_at(grid.find_index(letter))
    else
      bool = false
    end
  end
  return bool
end


def generate_grid(grid_size)
  # TODO: generate random grid of letters
  r_num_arr = []
  grid_size.times { |_i| r_num_arr << rand(65...90).chr }
  r_num_arr
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  time = timer(start_time, end_time)
  score = (time.to_i * -1) + (2 * attempt.length)
  message = "well done"
  trans = translator(attempt)

  if trans.upcase == attempt.upcase
    score = 0
    message = "not an english word"
    trans= nil
  end
  unless check_in_grid(attempt, grid)
    score = 0
    message = "not in the grid"
  end

  answer_hash = {
    time: time,
    translation: trans,
    score: score,
    message: message
  }
  answer_hash
end


end
