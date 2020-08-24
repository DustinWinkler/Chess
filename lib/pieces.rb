class King
  attr_reader :player
  attr_accessor :highlight
  def initialize(player)
    @player = player
    @highlight = false
  end

  def piece
    if @player == 1
      '♔'
    elsif @player == 2
      '♚'
    end
  end

end

class Queen
  attr_reader :player
  attr_accessor :highlight
  def initialize(player)
    @player = player
    @highlight = false
  end
  
  def piece
    if @player == 1
      '♕'
    elsif @player == 2
      '♛'
    end
  end
end

class Rook
  attr_reader :player
  attr_accessor :highlight
  def initialize(player)
    @player = player
    @highlight = false
  end
  
  def piece
    if @player == 1
      '♖'
    elsif @player == 2
      '♜'
    end
  end
end

class Bishop
  attr_reader :player
  attr_accessor :highlight
  def initialize(player)
    @player = player
    @highlight = false
  end
  
  def piece
    if @player == 1
      '♗'
    elsif @player == 2
      '♝'
    end
  end

end

class Knight
  attr_reader :player
  attr_accessor :highlight
  def initialize(player)
    @player = player
    @highlight = false
  end
  
  def piece
    if @player == 1
      '♘'
    elsif @player == 2
      '♞'
    end
  end

end

class Pawn
  attr_reader :player
  attr_accessor :highlight
  def initialize(player)
    @player = player
    @highlight = false
  end
  
  def piece
    if @player == 1
      '♙'
    elsif @player == 2
      '♟︎'
    end
  end

end