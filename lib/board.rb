class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) { Array.new(8, 0) }
    @board[0][0], @board[0][7] = Rook.new(1), Rook.new(1)
    @board[7][0], @board[7][7] = Rook.new(2), Rook.new(2)
    @board[0][1], @board[0][6] = Knight.new(1), Knight.new(1)
    @board[7][1], @board[7][6] = Knight.new(2), Knight.new(2)
    @board[0][2], @board[0][5] = Bishop.new(1), Bishop.new(1)
    @board[7][2], @board[7][5] = Bishop.new(2), Bishop.new(2)
    @board[0][3], @board[7][3] = Queen.new(1), Queen.new(2)
    @board[0][4], @board[7][4] = King.new(1), King.new(2)
    @board[1].map! { |piece| piece = Pawn.new(1) }
    @board[6].map! { |piece| piece = Pawn.new(2) }
  end

  def print_board(board = @board)
    i = 8
    board.reverse.each_with_index do |row, index|
      line = ''
      row.each_with_index do |space, index2|
        index % 2 == 0 ? index2 += 1 : index2 += 0
        if index2 % 2 == 0
          if space.class == Integer
            space == 0 ? line << "\e[44m#{'   '}\e[0m" : line << "\e[42m#{'   '}\e[0m"
          else
            space.highlight ? line << "\e[42m#{' ' + space.piece + ' '}\e[0m" : line << "\e[44m#{' ' + space.piece + ' '}\e[0m"
          end
        else 
          if space.class == Integer
            space == 0 ? line << "\e[40m#{'   '}\e[0m" : line << "\e[42m#{'   '}\e[0m"
          else
            space.highlight ? line << "\e[42m#{' ' + space.piece + ' '}\e[0m" : line << "\e[40m#{' ' + space.piece + ' '}\e[0m"
          end
        end
      end
      puts i.to_s + ' ' + line
      i -= 1
    end
    letters = '  '
    ('A'..'H').each { |letter| letters << (' ' + letter + ' ') }
    puts letters
  end

  def temp_board(board = @board)
    temp_board = []
    board.each do |row|
      to_pass_in = []      
      row.each do |space|
        to_pass_in << space.clone
      end
      temp_board << to_pass_in
    end
    temp_board
  end

  def highlight_print(array) # will highlight spaces a piece can go, given an array of moves
    temp = temp_board
    array.each do |coord|
      if temp[coord[0]][coord[1]].class == Integer
        temp[coord[0]][coord[1]] = 1
      else
        temp[coord[0]][coord[1]].highlight = true
      end
    end
    print_board(temp)
  end

  def at(coords)
    @board[coords[0]][coords[1]]
  end

  def show_moves(current_coords)
    current_coords = current_coords.reverse 
    if at(current_coords).class == Pawn
      moves = moves_allowed_pawn?(current_coords, at(current_coords).player)
    elsif at(current_coords).class == Knight
      moves = moves_allowed_knight?(current_coords, at(current_coords).player)
    elsif at(current_coords).class == Rook
      moves = moves_allowed_rook?(current_coords, at(current_coords).player)
    elsif at(current_coords).class == Bishop
      moves = moves_allowed_bishop?(current_coords, at(current_coords).player)
    elsif at(current_coords).class == Queen
      moves = moves_allowed_queen?(current_coords, at(current_coords).player)
    elsif at(current_coords).class == King
      moves = moves_allowed_king?(current_coords, at(current_coords).player)
    end
  end

  def move_piece(current_coords, new_coords, board = @board) 
    board[new_coords[0]][new_coords[1]] = board[current_coords[0]][current_coords[1]].clone
    board[current_coords[0]][current_coords[1]] = 0
    if board[new_coords[0]][new_coords[1]].class == Pawn
      if board[new_coords[0]][new_coords[1]].player == 1 && new_coords[0] == 7
        board[new_coords[0]][new_coords[1]] = Queen.new(1)
      elsif board[new_coords[0]][new_coords[1]].player == 2 && new_coords[0] == 0
        board[new_coords[0]][new_coords[1]] = Queen.new(2)
      end
    end
  end

  def moves_allowed_pawn?(current_coords, player)
    moves = []
    moved = false
    if player == 1
      current_coords[0] == 1 ? moved = false : moved = true
    else
      current_coords[0] == 6 ? moved = false : moved = true
    end

    if player == 1
      if @board[current_coords[0] + 1][current_coords[1]] == 0
        moves << [current_coords[0] + 1, current_coords[1]]
      end

      unless @board[current_coords[0] + 1][current_coords[1] + 1].class == Integer ||  @board[current_coords[0] + 1][current_coords[1] + 1].nil?
        if @board[current_coords[0] + 1][current_coords[1] + 1].player == 2
          moves << [current_coords[0] + 1, current_coords[1] + 1]
        end
      end

      unless @board[current_coords[0] + 1][current_coords[1] - 1].class == Integer ||  @board[current_coords[0] + 1][current_coords[1] - 1].nil?
        if @board[current_coords[0] + 1][current_coords[1] - 1].player == 2 && current_coords[1] - 1 >= 0
          moves << [current_coords[0] + 1, current_coords[1] - 1]
        end
      end

      unless moved
        if @board[current_coords[0] + 2] [current_coords[1]].class == Integer
          if @board[current_coords[0] + 1][current_coords[1]].class == Integer
            moves << [current_coords[0] + 2, current_coords[1]] 
          end
        end
      end
    end

    if player == 2
      if @board[current_coords[0] - 1][current_coords[1]] == 0
        moves << [current_coords[0] - 1, current_coords[1]]
      end

      unless @board[current_coords[0] - 1][current_coords[1] + 1].class == Integer ||  @board[current_coords[0] - 1][current_coords[1] + 1].nil?      
        if @board[current_coords[0] - 1][current_coords[1] + 1].player == 1
          moves << [current_coords[0] - 1, current_coords[1] + 1]
        end
      end

      unless @board[current_coords[0] - 1][current_coords[1] - 1].class == Integer ||  @board[current_coords[0] - 1][current_coords[1] - 1].nil?
        if @board[current_coords[0] - 1][current_coords[1] - 1].player == 1 && current_coords[1] - 1 >= 0
          moves << [current_coords[0] - 1, current_coords[1] - 1]
        end
      end

      unless moved
        if @board[current_coords[0] - 2] [current_coords[1]].class == Integer
          if @board[current_coords[0] - 1][current_coords[1]].class == Integer
            moves << [current_coords[0] - 2, current_coords[1]] 
          end
        end
      end
    end
    moves
  end

  def moves_allowed_knight?(current_coords, player)
    moves = []
    knight_moves = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
    knight_moves.each do |move|
      check_coord = [current_coords[0] + move[0], current_coords[1] + move[1]]
      next unless (check_coord[0].between?(0, 7) && check_coord[1].between?(0, 7))
      if at(check_coord) == 0
        moves << check_coord
      end

      unless at(check_coord).class == Integer
        if at(check_coord).player != player
          moves << check_coord
        end
      end
    end
    moves
  end

  def moves_allowed_rook?(current_coords, player)
    moves = []
    check_coord = [current_coords[0], current_coords[1]]
    8.times do
      check_coord[0] += 1
      break unless check_coord[0].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end

    check_coord = [current_coords[0], current_coords[1]]

    8.times do
      check_coord[0] -= 1
      break unless check_coord[0].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end

    check_coord = [current_coords[0], current_coords[1]]

    8.times do
      check_coord[1] += 1
      break unless check_coord[1].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end

    check_coord = [current_coords[0], current_coords[1]]

    8.times do
      check_coord[1] -= 1
      break unless check_coord[1].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end
    moves.uniq # probably dont need uniq here, was getting dupes earlier but it should be fixed
  end

  def moves_allowed_bishop?(current_coords, player)
    moves = []
    check_coord = [current_coords[0], current_coords[1]]
    8.times do
      check_coord[0] += 1
      check_coord[1] += 1
      break unless check_coord[0].between?(0,7) && check_coord[1].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end

    check_coord = [current_coords[0], current_coords[1]]

    8.times do
      check_coord[0] -= 1
      check_coord[1] += 1
      break unless check_coord[0].between?(0,7) && check_coord[1].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end

    check_coord = [current_coords[0], current_coords[1]]

    8.times do
      check_coord[0] += 1
      check_coord[1] -= 1
      break unless check_coord[0].between?(0,7) && check_coord[1].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end

    check_coord = [current_coords[0], current_coords[1]]

    8.times do
      check_coord[0] -= 1
      check_coord[1] -= 1
      break unless check_coord[0].between?(0,7) && check_coord[1].between?(0,7)
      if at(check_coord) == 0
        moves << [check_coord[0], check_coord[1]]
      elsif at(check_coord).class != Integer
        moves << check_coord if at(check_coord).player != player
        break
      end
    end
    moves.uniq
  end

  def moves_allowed_queen?(current_coords, player)
    moves = []
    moves << moves_allowed_bishop?(current_coords, player)
    moves << moves_allowed_rook?(current_coords, player)
    moves.flatten(1)
  end

  def moves_allowed_king?(current_coords, player)
    moves = []
    moves << moves_allowed_bishop?(current_coords, player)
    moves << moves_allowed_rook?(current_coords, player)
    moves.flatten!(1)
    moves.filter! do |coord|
      (current_coords[0] - coord[0]).between?(-1,1) && (current_coords[1] - coord[1]).between?(-1,1) 
    end
    moves
  end

  def convert_coords(coords) # receive something like B2 and return 1, 1 for real @board coords
    converted = []
    coords = coords.split('')
    converted << coords[0].downcase.ord - 97
    converted << coords[1].to_i - 1
    converted
  end

  def valid_move?(coords) # receives board coordinates i.e A2
    coords.split('')[0].downcase.between?('a', 'h') ? letter = true : letter = false
    coords.split('')[1].to_i.between?(1, 8) ? number = true : number = false
    letter && number
  end

  def check?(board = @board)
    check1 = false
    check2 = false
    board.each_with_index do |row, i|
      row.each_with_index do |piece, i2|
        next if piece == 0 || piece == nil
        moves = show_moves([i2, i])
        next if moves.nil? || moves.empty?

        moves.each do |move|
          if board[move[0]][move[1]].class == King
            if board[move[0]][move[1]].player == 1
              check1 = true if piece.player != 1
            else
              check2 = true if piece.player != 2
            end
          end
        end
      end
    end
    [check1, check2]
  end
# checking every possible move and running check? on that potential board state, if all return true from check? then its a checkmate
  def checkmate?
    checks1 = []
    checks2 = []
    piece_coords1 = []
    piece_coords2 = []
    king_coords1 = []
    king_coords2 = []
    # getting coords for every piece
    @board.each_with_index do |row, i|
      row.each_with_index do |space, i2|
        if space.class != Integer
          space.player == 1 ? piece_coords1 << [i2, i] : piece_coords2 << [i2, i]
        end
      end
    end
    # getting coords for both Kings
    @board.each_with_index do |row, i|
      row.each_with_index do |space, i2|
        if space.class == King
          space.player == 1 ? king_coords1.push(i2, i) : king_coords2.push(i2, i)
        end
      end
    end
    # for each piece, getting possible moves, for each move seeing if King would be in check
    if king_coords1.empty?
      checks1 = [true]
    else
      piece_coords1.each do |coords|
        moves = show_moves(coords)
        moves.each do |move|
          temp = temp_board
          move_piece(coords.reverse, move, temp)
          checks1 << check?(temp)[0]
        end
      end
    end

    if king_coords2.empty?
      checks2 = [true]
    else
      piece_coords2.each do |coords|
        moves = show_moves(coords)
        moves.each do |move|
          temp = temp_board
          move_piece(coords.reverse, move, temp)
          checks2 << check?(temp)[1]
        end
      end
    end
    [checks1, checks2] # checkmate is true if checks1.all? || checks2.all? == true 1 refers to player 1 and 2 refers to player 2
  end

end
