#created by stjohnej
#https://stjohnej.itch.io/
#https://github.com/stjohnej

#v1.0.0
#build 1

require 'json'

parties = File.readlines("parties.txt", chomp: true)

options = {
  "map" => "Classic_2024",
  "turns" => 30,
  "players" => 2,
  #advanced below
  "rally_effect_min" => 0.0,
  "rally_effect_max" => 2.0,
  "rally_cost" => 6,
  "poll_cost" => 1,
  "starting_money" => 6,
  "turn_money" => 5,
  "max_money" => 16
}

players = []

system("cls") || system("clear")

def main_menu(options)
  system("cls") || system("clear")
  puts "\n\n\t\t\t\t----Main Menu----\nEnter the number of the desired option to modify it. Enter blank to confirm the options.\n"
  puts "----------------------------------------------------------------------------------------"
  puts "1. Map\t\t\t\t\t\t" + options["map"]
  puts "2. Amount of Players\t\t\t\t" + options["players"].to_s
  puts "3. Amount of Turns\t\t\t\t" + options["turns"].to_s
  puts "4. Advanced Options\n"
  puts "5. What the heck is happening"
  print "\n"
end

def advanced_menu(options)
  system("cls") || system("clear")
  puts "\n\n\t\t\t\t---+Advanced Options+---\nEnter the number of the desired option to modify it. Enter blank to confirm the options.\n"
  puts "========================================================================================"
  puts "1. rally_effect_min\t\t\t" + options["rally_effect_min"].to_s
  puts "2. rally_effect_max\t\t\t" + options["rally_effect_max"].to_s
  puts "3. rally_cost\t\t\t\t" + options["rally_cost"].to_s
  puts "4. poll_cost\t\t\t\t" + options["poll_cost"].to_s
  puts "5. starting_money\t\t\t" + options["starting_money"].to_s
  puts "6. turn_money\t\t\t\t" + options["turn_money"].to_s
  puts "7. max_money\t\t\t\t" + options["max_money"].to_s
  print "\n"
end

def rally_effect(options, players, map, turn, state)
  random = rand(options["rally_effect_min"]..options["rally_effect_max"])
  i = 0
  while i < options["players"]

    if i != turn
      if not players[i][:percents][map["states"].keys.index(state)] - (random.to_f / (options["players"] - 1)) < 0
        players[i][:percents][map["states"].keys.index(state)] = (players[i][:percents][map["states"].keys.index(state)] - (random.to_f / (options["players"] - 1))).round(1)
      else
        players[i][:percents][map["states"].keys.index(state)] = 0.0
      end
    end

    i = i + 1
  end
  
  if not players[turn][:percents][map["states"].keys.index(state)] + random.to_f > 100
    players[turn][:percents][map["states"].keys.index(state)] = (players[turn][:percents][map["states"].keys.index(state)] + random.to_f).round(1)
  else
    players[turn][:percents][map["states"].keys.index(state)] = 100.0
  end
end

choose = 'blank'
while not choose == ''
  main_menu(options)

  print '>>> '
  choose = gets.chomp

  if choose == '1'
    #change map
    system("cls") || system("clear")
    i = 0
    while i < Dir["maps/**/*.json"].count
      puts Dir["maps/*"][i].delete_prefix('maps/').delete_suffix('.json')
      i = i + 1
    end
    print "\n"
    options["map"] = gets.chomp

  elsif choose == '2'
    #change amount of players
    main_menu(options)
    print 'Enter desired amount of players >>> '
    choose = gets.to_i
    if choose > 1 and choose < 13
      options["players"] = choose
    elsif choose < 2
      options["players"] = 2
    elsif choose > 12
      options["players"] = 12
    end

  elsif choose == '3'
    #change amount of turns
    main_menu(options)
    print 'Enter desired amount of turns >>> '
    choose = gets.to_i
    if choose > 0
      options["turns"] = choose
    else
      options["turns"] = 1
    end

  elsif choose == '4'
    #view advanced options
    while choose != ''
      advanced_menu(options)
      #advanced options changing
      print '>>> '
      choose = gets.chomp
      if choose == '1'
        advanced_menu(options)
        print 'rally_effect >>> '
        options["rally_effect"] = gets.to_i
      elsif choose == '2'
        advanced_menu(options)
        print 'rally_cost >>> '
        options["rally_cost"] = gets.to_i
      elsif choose == '3'
        advanced_menu(options)
        print 'poll_cost >>> '
        options["poll_cost"] = gets.to_i
      elsif choose == '4'
        advanced_menu(options)
        print 'starting_money >>> '
        options["starting_money"] = gets.to_i
      elsif choose == '5'
        advanced_menu(options)
        print 'turn_money >>> '
        options["turn_money"] = gets.to_i
      elsif choose == '6'
        advanced_menu(options)
        print 'max_money >>> '
        options["max_money"] = gets.to_i
      end
    end
    choose = 'blank'

  elsif choose == '5'
    #What the heck is happening
    system("cls") || system("clear")
    puts "If you want to learn what the options do and how to play, read this!:"
    puts "https://docs.google.com/document/d/e/2PACX-1vQp6yKd69M4mLommAknWSrMLZddvWe2nRkpXc1ymWcnl1vuDTasCygkAdjxBT8cQdX1WOKLQ9VlNIQF/pub \n\n"
    puts "If you are looking for who created this or where you can download the latest version, go to one of these links:"
    puts "https://stjohnej.itch.io"
    puts "https://github.com/stjohnej"
    gets
  end
end

#load map
map = JSON.parse(File.read("maps/#{options["map"]}.json"))
map.keys

print "\n"
i = 0
while i < options["players"]
  system("cls") || system("clear")
  i = i + 1
  print "The nominee of the " + parties[options["players"]-i] + ' Party is >>> '
  choose = gets.chomp
  players << {name: choose, party: parties[options["players"]-i], money: options["starting_money"], percents: [], votes: 0}
  u = 0
  while u < map["states"].length
    players.last[:percents] << 100/options["players"]
    u = u + 1
  end
end

system("cls") || system("clear")

days = 0
while days < options["turns"]
  turn = players.length
  while turn > 0
    turn = turn - 1
    system("cls") || system("clear")
    players[turn][:money] = players[turn][:money] + options["turn_money"]
    if players[turn][:money] > options["max_money"]
      players[turn][:money] = options["max_money"]
    end
    puts "It's #{players[turn][:name]}'s turn. Hit enter/return when you're ready."
    gets

    loop do
      system("cls") || system("clear")
      puts "#{players[turn][:name]} of the #{players[turn][:party]} Party"
      if options["turns"] - (days + 1) == 1
        puts "#{options["turns"] - (days + 1)} turn for you after this turn\n"
      elsif not options["turns"] - (days + 1) == 0
        puts "#{options["turns"] - (days + 1)} turns for you after this turn\n"
      else
        puts "THIS IS YOUR LAST TURN!\n"
      end
      puts "$#{players[turn][:money]}\n\n\n"

      puts '1. Rally'
      puts '2. Poll'
      puts '3. Finish'
      print "Enter the number of which move you'd like to use >>> "
      choose = gets.chomp
    if choose == '1'
      system("cls") || system("clear")
      print "Where would you like to Rally? Don't enter something that exists to escape >>> "
      choose = gets.chomp
      if map["states"].include?(choose) and players[turn][:money] > (options["rally_cost"] - 1)
        rally_effect(options, players, map, turn, choose)
        players[turn][:money] = players[turn][:money] - options["rally_cost"]
      elsif (not map["states"].include?(choose)) and not choose == ''
        system("cls") || system("clear")
        print 'Does not exist'
        gets
      end
    elsif choose == '2'
      system("cls") || system("clear")
      print "Where would you like to Poll? Don't enter something that exists to escape >>> "
      choose = gets.chomp
      if map["states"].include?(choose) and players[turn][:money] > (options["poll_cost"] - 1)
        state_index = map["states"].keys.index(choose)
        puts "\n#{choose} - #{map["states"][choose]} electoral votes"
        i = 0
        while i < options["players"]
          puts "#{players[i][:name]} | #{players[i][:percents][state_index]}"
          i = i + 1
        end
        players[turn][:money] = players[turn][:money] - options["poll_cost"]
        gets
      elsif (not map["states"].include?(choose)) and not choose == ''
        system("cls") || system("clear")
        print 'Does not exist'
        gets
      end
      
    elsif choose == '3'
        break
      end
    end
  end
  days = days + 1
end


#results
i = 0
while i < map["states"].length
  best = 0
  tied = false
  u = 1
  while u < options["players"]
    if players[u][:percents][i] > players[best][:percents][i]
      best = u
      tied = false
    elsif players[u][:percents][i] == players[best][:percents][i]
      tied = true
    end
    u = u + 1
  end
  if not tied
    players[best][:votes] = players[best][:votes] + map["states"].to_a[i][1]
  end
  i = i + 1
end

system("cls") || system("clear")
i = 0
while i < options["players"]
  puts "#{players[i][:name]} of the #{players[i][:party]} Party   -   #{players[i][:votes]} electoral votes"
  i = i + 1
end