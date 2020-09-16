require "open-uri"

class GamesController < ApplicationController

  
  def new
    @initial_time = Time.now
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample(1)[0] }
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    @final_time = Time.now
    @initial_time = params[:initial_time].to_time
    @valid_word = @word.chars.all? { |letter| @letters.count(letter) >= @word.count(letter) }

    if @valid_word
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      html = open(url).read
      result = JSON.parse(html)
      @found = result["found"]
      @score = (@word.length / ((@final_time - @initial_time) / 60)).round(2) if @found
      @result = @found ? "Good Job! You scored #{@score} points!" : "#{@word} is not an english word."
    else
      @result = "#{@word} is not a valid word. Please use only letters from the grid: #{@letters.chars.join(" ")}."
    end
  end
end
