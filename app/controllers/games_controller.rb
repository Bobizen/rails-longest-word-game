require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = generate_grid(7)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def score
    guess = params['word']
    grid = params['letters']

    @result = score_and_message(guess, grid)
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        # score = compute_score(attempt, time)
        [10, "well done"]
      else
        [0, "sorry, but #{attempt} is not an english word"]
      end
    else
      listofletters = grid.split(',') { |substring| p substring }
      [0, "sorry, but #{attempt} can't be build from #{listofletters}"]
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
