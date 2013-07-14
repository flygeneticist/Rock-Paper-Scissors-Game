require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?

#before prossessing a move set responce as plain text
# setup array of valid moves that player and computer can perform
before do
  content_type = :txt
  @defeat = {rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
end

get '/' do
  erb :form # loads main layout page
end

post '/throw' do
  redirect '/throw/'+params['choice'].downcase.to_s
end

get '/throw/:type' do
  #params[] hash stores querysting and form data
  player_throw = params[:type].to_sym
  @player_throw = case player_throw
    when :rock
      then '/rock.jpg'
    when :paper
      then '/paper.jpg'
    when :scissors
      then '/scissor.jpg'
    end

  # if player makes invalid pick halt code with 403 status (Forbidden)
  if !@throws.include?(player_throw)
    halt 403, "You must throw one of the following: #{@throws}"
  end

  # computer throw randomly picked and compared to player's
  computer_throw = @throws.sample
  @computer_throw = case computer_throw
    when :rock
      then '/rock.jpg'
    when :paper
      then '/paper.jpg'
    when :scissors
      then '/scissor.jpg'
    end

  if player_throw == computer_throw
    @result = "You tied the computer. Try again!"
  elsif computer_throw == @defeat[player_throw]
    @result = "Nicely done; #{player_throw} beats #{computer_throw}!"
  else
    @result = "Ouch; #{computer_throw} beats #{player_throw}. Better luck next time!"
  end
  erb :results
end
