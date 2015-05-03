require 'colorize'

class Player
  #put all Player specific logic & properties
  attr_accessor :life, :games
  attr_reader :name

  @@num_players = 0

  def initialize(name: name)
    @name = name
    @life = 3
    @games = 0
    @@num_players += 1
  end

  def Player.count #class method
    @@num_players
  end

  def lose_life
    @life -= 1
  end

  def gain_game_point
    @games += 1
  end

  def life_reset # is there a way to reset one specific argument for all objects of same class via a class method?
    @life = 3
  end
end

def play
  player = rand(0..Player.count - 1)
  until game_over?
    x = rand(1..20)
    y = rand(1..20)

    # TODO separate out into method?
    operator = rand(1..3)
    case operator
      when 1
        operator = "+"
        answer = x + y
      when 2
        operator = "-"
        answer = x - y
      when 3
        operator = "*"
        answer = x * y
    end

    puts "\n#{@players[player].name}: #{x} #{operator} #{y} = ???"

    if gets.chomp.to_i == answer
      puts "Correct!".green
    else
      puts "Oops. The correct answer was #{answer}".red
      @players[player].lose_life
      print_lives
    end
    player = (player == (Player.count - 1)) ? 0 : player + 1
  end
  winner_is
end

def print_lives
  puts "*****"
  for i in 0..Player.count - 1
    puts "#{@players[i].name}: #{@players[i].life} pt(s)".light_blue
  end
  puts "*****"
end

def print_game_tally
  puts "*****"
  for i in 0..Player.count - 1
    puts "#{@players[i].name}: #{@players[i].games} game(s)".blue
  end
  puts "*****"
end

def game_over?
  @players.each { |player| return true if player.life == 0 }
  false
end

def winner_is
  @players.sort_by! { |player| [player.life] }
  @players.reverse!
  if @players[0].life == @players[1].life
    puts "There's a tie! (nobody 'wins')"
  else
    puts "\n#{@players[0].name} wins!!! Keeping track of game wins:".blue
    @players[0].gain_game_point
  end   
  print_game_tally
end

def play_again?
  puts "________________________________________________"
  puts "Type 'yes' to play again...(anything else exits)"
  gets.chomp == "yes"
end

@players = []
puts "How many players?"
num_players = gets.chomp.to_i

for i in 0..num_players - 1
  puts "Player #{i + 1}: what is your name?"  
  @players.push(Player.new(name: gets.chomp)) # inside Player class
end

if Player.count < 1
  puts "Invalied number of players"
elsif Player.count == 1
  winner_is
  #don't ask to play again
else
  play
  while play_again? 
    for i in 0..2 #(Player.count - 1)
      @players[i].life_reset
    end
    play
  end
end