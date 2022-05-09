require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabet = ("a".."z").to_a
    10.times { @letters << alphabet[rand(26)] }
    # @letters = generate_grid
  end

  def score
    # byebug
    url = "https://wagon-dictionary.herokuapp.com/#{params[:query]}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    starting = params[:starting]
    starting = Time.parse(starting)
    time = (Time.now - starting)
    @letters = params[:letters].gsub(" ","").chars
    grid = @letters.join
    attempt_array = params[:query].downcase.chars
    result = {}
    attempt_array.each do |char|
      if grid.match?(/#{char}/)
        grid = grid.sub(char, "")
      elsif grid.match?(/#{char}/) == false
        result = {
          score: 0,
          message: "not in the grid",
          time: time.to_i
        }
      end
    end

    if result.empty? == true
      result = {
        score: (user["length"].to_i**6.0) - (time.to_i),
        # score: (user["length"].to_i**3.0),
        message: "Well Done!",
        time: time
      }
    end

    if user["found"] == false
      result = {
        score: 0,
        message: "not an english word",
        time: time.to_i
      }
    end
    @result = result
  end

  # def generate_grid
  #   letters = []
  #   alphabet = ("a".."z").to_a
  #   10.times { letters << alphabet[rand(26)] }
  #   return
  # end
end
