require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    # binding.pry
    params[:authenticity_token]
    params[:guess]
    found = parse_word(params[:guess])
    binding.pry
  end

  def parse_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_valid_check_serialized = URI.open(url).read
    word_valid_check = JSON.parse(word_valid_check_serialized)
    return word_valid_check['found']
  end


end
