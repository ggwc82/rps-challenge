require 'sinatra/base'
require './lib/player'
require './lib/game'

class RPS < Sinatra::Base

  enable :sessions

  get '/' do
    erb(:index)
  end

  post '/game_type' do
    $game_type = params[:game]
    redirect '/hvsc' if $game_type == 'HvsC'
    redirect '/hvsh'
  end

  get '/hvsc' do
    erb(:hvsc)
  end

  get '/hvsh' do
    erb(:hvsh)
  end

  post '/names' do
    if $game_type == 'HvsC'
      player1 = Player.new(params[:Player_1_Name])
      $game = Game.new([player1])
    else
      player1 = Player.new(params[:Player_1_Name])
      player2 = Player.new(params[:Player_2_Name])
      $game = Game.new([player1, player2])
    end
    redirect '/play'
  end

  get '/play' do   
    erb(:play)
  end

  get '/player1_pick' do
    @player_1 = $game.players.first
    erb(:player1_pick)
  end

  post '/player1_has_picked' do
    @player_1 = $game.players.first
    @player_1.choice = params[:hand1]
    if $game_type == 'HvsC'
      $game.pick_cpu_hand
      redirect '/end'
    else
      redirect '/player2_pick'
    end
  end

  get '/player2_pick' do
    @player_2 = $game.players.last   
    erb(:player2_pick)
  end

  post '/player2_has_picked' do
    @player_2 = $game.players.last
    @player_2.choice = params[:hand2]
    redirect '/end'
  end

  get '/end' do
    @result = $game.result
    erb(:end)
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
