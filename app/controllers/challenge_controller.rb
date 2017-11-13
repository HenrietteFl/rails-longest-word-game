require 'open-uri'
require 'json'

MESSAGE = {
  1 => "Well done",
  2 => "not an English word",
  3 =>  "not in the grid",
}

class ChallengeController < ApplicationController

  def game
    alphabet = []
    alphabet = ('A'..'Z').to_a
    @grid = alphabet.sample(params[:grid_size].to_i).join.upcase  # htmnl user input
    session[:start_time] = Time.now
    session[:grid] = @grid
  end

  def score
    @start_time = Time.parse(session[:start_time])
    @guess = params[:grid_guess].upcase.split(//) # htmnl user input
    @end_time = Time.now
    @grid = session[:grid]

    @time_taken = @end_time - @start_time

    letter_included = @guess.all? { |letter| @guess.count(letter) <= @grid.count(letter) }

    response = open("https://wagon-dictionary.herokuapp.com/#{@guess.join}")
    json = JSON.parse(response.read)
    found_word = json['found']

    @score = (!found_word && @time_taken.to_i > 60.0 ? 0 : @guess.size * (1.0 - @time_taken.to_i / 60.0)).round(2)

    @message = if letter_included
      if found_word
        "#{MESSAGE[1]}"
      else
        "#{MESSAGE[2]}"
      end
    else
      "#{MESSAGE[3]}"
    end
  end
end




