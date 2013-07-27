require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'

#before prossessing a move set responce as plain text
# setup array of valid moves that player and computer can perform
before do
  content_type = :txt
  @defeat = {rock: :scissors, rock: :lizard, paper: :rock, paper: :spock,
            scissors: :paper, scissors: :lizard, lizard: :spock, spock: :scissors,
            spock: :rock, lizard: :paper}
  @throws = @defeat.keys
end

get '/' do
  haml :form # loads main layout page
end

post '/' do
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
    when :lizard
      then '/lizard.jpg'
    when :spock
      then '/spock.jpg'
    end

  # if player makes invalid pick halt code with 403 status (Forbidden)
  if !@throws.include?(player_throw)
    haml :wrong_pick
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
    when :lizard
      then '/lizard.jpg'
    when :spock
      then '/spock.jpg'
    end

  if player_throw == computer_throw
    @result = "You tied the computer. Try again!"
  elsif computer_throw == @defeat[player_throw]
    @result = "Nicely done; #{player_throw} beats #{computer_throw}!"
  else
    @result = "Ouch; #{computer_throw} beats #{player_throw}. Better luck next time!"
  end
  haml :results
end
