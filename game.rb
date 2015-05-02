require 'colorize'
@players = []
# [{name: "Benjamin", life: 3}, {name: "Sarah", life: 3}]

def play
  # reset lives for num_players
  for i in 0..@num_players - 1
    @players[i][:life] = 3
  end

  player = rand(0..@num_players - 1)
  until game_over?
    x = random_num
    y = random_num

    # TODO separate out into method
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

    puts "\n#{@players[player][:name]}: #{x} #{operator} #{y} = ???"

    if gets.chomp.to_i == answer
      puts "Correct!".green
    else
      puts "Oops. The correct answer was #{answer}".red
      lose_life(player)
      print_lives
    end
    player = (player == (@num_players - 1)) ? 0 : player + 1
  end
  winner_is(player)
end

def lose_life(player)
  @players[player][:life] -= 1
end

def print_lives
  puts "*****"
  for i in 0..@num_players - 1
    puts "#{@players[i][:name]}: #{@players[i][:life]} pt(s)".light_blue
  end
  puts "*****"
end

def print_game_tally
  puts "*****"
  for i in 0..@num_players - 1
    puts "#{@players[i][:name]}: #{@players[i][:games]} game(s)".blue
  end
  puts "*****"
end

def random_num
  rand(1..20)
end

def game_over?
  @players.each { |player| return true if player[:life] == 0 }
  false
end

def winner_is(player)
  if @num_players <= 2
    puts "\n#{@players[player][:name]} wins!!! Keeping track of game wins:".blue   
    @players[player][:games] += 1
  elsif @num_players > 2
    winning_order = (@players.sort_by! { |player| [player[:life]] }).reverse
    if winning_order[0][:life] == winning_order[1][:life]
      puts "There's a tie! (nobody 'wins')"
    else
      puts "\n#{winning_order[0][:name]} wins!!! Keeping track of game wins:".blue
      @players[player][:games] += 1
    end   
  end
  print_game_tally
end

def play_again?
  puts "________________________________________________"
  puts "Type 'yes' to play again...(anything else exits)"
  gets.chomp == "yes"
end

puts "How many players?"
@num_players = gets.chomp.to_i
#@players = [{name: "Benjamin", life: 1}, {name: "Sarah", life: 3}. {name: "Monica", life: 3}] # TODO why not working?
for i in 0..@num_players - 1
  puts "Player #{i + 1}: what is your name?"
  @players.push({name: gets.chomp, life: 3, games: 0}) 
end

if @num_players < 1
  puts "Invalied number of players"
elsif @num_players == 1
  winner_is(0)
else
  play
  while play_again? 
    play
  end
end