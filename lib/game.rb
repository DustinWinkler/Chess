require 'yaml'
require_relative 'board'
require_relative 'pieces'

unless Dir.exist?('Saves')
  Dir.mkdir('Saves')
end

saves = Dir.children('Saves') 
save_opened = false
puts "Would you like to load a save? Y/N?"
choice = gets.chomp.upcase
until choice == 'Y' || choice == 'N'
  puts 'That was not a valid choice. Try again.'
  choice = gets.chomp
end

if choice == 'N'
  b = Board.new
elsif saves.empty?
  puts 'There are no save files. We will start a new game'
  sleep(2)
  b = Board.new
elsif choice == 'Y' && !saves.empty?
  save_opened = true
  puts 'Which save would you like to load?'
  puts saves
  save = gets.chomp
  until saves.include?(save)
    puts 'That was not a valid choice, try again'
    save = gets.chomp
  end 
  opensave = File.open("Saves/#{save}", 'r+')
  b = YAML::load(opensave)
end

until b.checkmate?[0].all? == true || b.checkmate?[1].all? == true
  b.print_board
  puts "Player 1, choose a piece to move, Ex. 'C2' or type 'save' to save game" 
  choice = gets.chomp
  if choice == 'save'
    newsave = YAML::dump(b)
    puts "What you like to title this save?"
    name = gets.chomp
    File.open("Saves/#{name}", 'w').write(newsave)
    exit
  end
  until (b.valid_move?(choice)) && (b.board[b.convert_coords(choice)[1]][b.convert_coords(choice)[0]].class != Integer) && (b.board[b.convert_coords(choice)[1]][b.convert_coords(choice)[0]].player == 1) && b.show_moves(b.convert_coords(choice)).any?
    if b.board[b.convert_coords(choice)[1]][b.convert_coords(choice)[0]].class == Integer
      puts 'There is no piece there, try again'
    else
      puts 'That piece has no moves allowed, try a different piece'
    end
    choice = gets.chomp
  end

  b.highlight_print(b.show_moves(b.convert_coords(choice)))
  puts 'These are the possible moves for that piece. Which space would you like to move it to?'
  moves = (b.show_moves(b.convert_coords(choice)))
  move_choice = gets.chomp
  until moves.include?(b.convert_coords(move_choice).reverse)
    puts 'That is not a valid move'
    move_choice = gets.chomp
  end
  b.move_piece(b.convert_coords(choice).reverse, b.convert_coords(move_choice).reverse)

  break if b.checkmate?[0].all? == true || b.checkmate?[1].all? == true
  
  b.print_board
  if b.check?.any?
    if b.check?.all?
      puts 'Both players are in check'
    else
      puts (b.check?[0]) ? "Player 1 is in check!" : "Player 2 is in check!"
    end
  end
  puts "Player 2, choose a piece to move, Ex. 'C7'"
  choice = gets.chomp

  until b.valid_move?(choice) && b.board[b.convert_coords(choice)[1]][b.convert_coords(choice)[0]].class != Integer && b.board[b.convert_coords(choice)[1]][b.convert_coords(choice)[0]].player == 2 && b.show_moves(b.convert_coords(choice)).any?
    if b.board[b.convert_coords(choice)[1]][b.convert_coords(choice)[0]].class == Integer
      puts 'There is no piece there, try again'
    else
      puts 'That piece has no moves allowed, try a different piece'
    end
    choice = gets.chomp
  end

  p b.convert_coords(choice)
  b.highlight_print(b.show_moves(b.convert_coords(choice)))
  puts 'These are the possible moves for that piece. Which space would you like to move it to?'
  moves = (b.show_moves(b.convert_coords(choice)))
  move_choice = gets.chomp
  until moves.include?(b.convert_coords(move_choice).reverse)
    puts 'That is not a valid move'
    move_choice = gets.chomp
  end
  b.move_piece(b.convert_coords(choice).reverse, b.convert_coords(move_choice).reverse)
  if b.check?.any?
    if b.check?.all?
      puts 'Both players are in check'
    else
      puts (b.check?[0]) ? "Player 1 is in check!" : "Player 2 is in check!"
    end
  end
end

b.print_board

if b.checkmate?[1].all? == true 
  puts 'Player 1 wins!' 
else 
  puts 'Player 2 wins!'
end

if save_opened
  File.delete(opensave)
end
