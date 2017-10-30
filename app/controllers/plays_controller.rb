require 'open-uri'
require 'json'

class PlaysController < ApplicationController
  def game
    @grid = generate_grid(15)
    @start_time = DateTime.now
  end

  def score
    @attempt = params[:attempt]
    @end_time = DateTime.now.to_i
    @start_time = (params[:start_time]).to_datetime.to_i
    @grid = params[:grid].split('')
    @results = run_game(@attempt, @grid, @start_time, @end_time)
    session[:games] = [] unless session[:games]
    session[:games] << @results[:score]
    @past_games = session[:games]

  end

  def home
  end
end

private

def generate_grid(grid_size)
  grid = (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
end

def check_if_in_grid(attempt, grid)
  attempt = attempt.upcase.split('')
  attempt_hash = {}
  grid_hash = {}

  attempt.each { |item| attempt_hash[item].nil? ? attempt_hash[item] = 1 : attempt_hash[item] += 1 }
  grid.each { |item| grid_hash[item].nil? ? grid_hash[item] = 1 : grid_hash[item] += 1 }

  attempt_hash.each do |k,v|
    unless grid_hash.keys.include?(k)
      "the given word is not in the grid"
      return false
    end
    unless attempt_hash[k] <= grid_hash[k]
      "the given word has the correct letters but not in sufficient number"
      return false
    end
  end
  return true
end

def run_game(attempt, grid, start_time, end_time)
  game = {score: 0, time: 0, message: 0}
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  if check_if_in_grid(attempt,grid)
    if JSON.parse(open(url).read)["found"] == true
      game[:score] = attempt.length*100/(end_time - start_time)
      # raise
      game[:time] = (end_time - start_time)
      game[:message] = "well done"
    else
      game[:message] = "not an english word"
    end
  else
    game[:message] = "not in the grid"
  end
  game
end
