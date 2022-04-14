require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    if cookies.key?(:playerscore) == false
      cookies[:playerscore] = { value: 0, expires: Time.now + 1.hour}
    end
  end

  def score
    # binding.pry
    params[:authenticity_token]
    @letters = params[:grid].downcase
    @guess = params[:guess].downcase
    @results = result(english_word?(@guess), word_in_grid?(@guess))
  end

  private

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_valid_check_serialized = URI.open(url).read
    word_valid_check = JSON.parse(word_valid_check_serialized)
    return word_valid_check['found']
  end

  def gen_grid
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def word_in_grid?(attempt)
    attempt.split.all? { |letter| attempt.count(letter) <= @letters.count(letter) }
  end

  def result(english_check, in_grid_check)
    if english_check && in_grid_check
      cookies[:playerscore] = @guess.length + cookies[:playerscore].to_i
      "Congratulations! <strong> #{@guess.upcase} </strong> is a valid English word!"
    elsif in_grid_check && english_check == false
      "Sorry but <strong> #{@guess.upcase} </strong> does not seem to be a valid English word..."
    else
      "Sorry but <strong> #{@guess.upcase} </strong> can't be built out of #{@letters.upcase.gsub(/\B/, ', ')}"
    end
  end
end
