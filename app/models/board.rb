class Board < ActiveRecord::Base
  
  has_many :squares
  after_save :create_squares
        
  def create_squares
    9.times do |i|
      square = Square.new({
        :board_id => self.id,
        :val => nil
        })
        
      case i
        when 0..2
          square.y_value = 0  
        when 3..5
          square.y_value = 1
        when 6..8
          square.y_value = 2    
      end
      
      case
        when i % 3 == 0
          square.x_value = 0
        when i % 3 == 1
          square.x_value = 1
        when i % 3
          square.x_value = 2 
      end    
      
      square.save!
    end
  end
  
  def calculate_computer_move(human_square)
    # Make Initial Move
    return make_initial_move if first_move?
    
    # Take a winning move if it's available
    if winning_move
      winning_move.update_attributes(:winner => true) 
      return computer_take_square(winning_move.x_value, winning_move.y_value)
    end
        
    # Block the player from winning if the player has a chance to win
    blocking_square = blocking_move(human_square)
    return computer_take_square(blocking_square.x_value, blocking_square.y_value) if blocking_square
    
    # If the user tries a two corner opening move, block it
    return computer_take_square(prevent_two_corner_win.x_value, prevent_two_corner_win.y_value) if prevent_two_corner_win
    
    # If none of those scenarios are present... take a corner if it's available
    first_corner = take_first_corner
    return computer_take_square(first_corner.x_value, first_corner.y_value) if first_corner
    
    # now check if there's a side that's avaialble
    first_side = take_first_side
    return computer_take_square(first_side.x_value, first_side.y_value) if first_side
    
    # Handle Draws
    return nil
  end
  
  def human_take_square(x,y)
    square = Square.where(:board_id => self.id).where(:x_value => x).where(:y_value => y).first
    square.update_attributes(:val => "X")
    return square 
  end
  
  def computer_take_square(x,y)
    square = Square.where(:board_id => self.id).where(:x_value => x).where(:y_value => y).first
    square.update_attributes(:val => "O")
    return square
  end
  
  def square_taken?(x,y)
    Square.where(:board_id => self.id).where(:x_value => x).where(:y_value => y).first.val? ? true : false;
  end
  
  def first_move?
    Square.where(:board_id => self.id).where(:val => nil).count == 8 ? true : false;
  end

  def make_initial_move
    return computer_take_square(1,1) unless square_taken?(1,1)
    return computer_take_square(0,0) unless square_taken?(0,0)
  end
  
  def winning_move
    board = Square.where(:board_id => self.id) 
    empty_squares = board.select { |sq| !sq.val }
    
    [0, 1, 2].each do |i|
      computer_moves_in_row = board.select { |sq| sq.val == "O" && sq.y_value == i }
      row_winner = empty_squares.find { |sq| sq.y_value == i } if computer_moves_in_row.count == 2
      return row_winner if row_winner
      
      computer_moves_in_column = board.select { |sq| sq.val == "O" && sq.x_value == i }
      column_winner = empty_squares.find { |sq| sq.x_value == i } if computer_moves_in_column.count == 2
      return column_winner if column_winner
      
      next if i == 0
      computer_moves_in_diag = board.select { |sq| sq.val == "O" && ( diag_for(sq) == i || diag_for(sq) == 3 ) }
      diag_winner = empty_squares.find { |sq| diag_for(sq) == i } if computer_moves_in_diag.count == 2
      return diag_winner if diag_winner
    end
    
    return nil
    
  end

  def blocking_move(human_square)
    board = Square.where(:board_id => self.id) 
    empty_squares = board.select { |sq| !sq.val }
    
    player_moves_in_current_column = board.select { |sq| sq.val == "X" && sq.x_value == human_square.x_value }
    column_winner = empty_squares.find { |sq| sq.x_value == human_square.x_value } if player_moves_in_current_column.count == 2
    return column_winner if column_winner
    
    player_moves_in_current_row = board.select { |sq| sq.val == "X" && sq.y_value == human_square.y_value }
    row_winner = empty_squares.find { |sq| sq.y_value == human_square.y_value } if player_moves_in_current_row.count == 2
    return row_winner if row_winner
    
    player_moves_in_current_diag = board.select { |sq| sq.val == "X" && ( ( diag_for(sq) == diag_for(human_square) && diag_for(human_square) )|| diag_for(sq) == 3 ) }
    diag_winner = empty_squares.find { |sq| diag_for(sq) == diag_for(human_square) } if player_moves_in_current_diag.count == 2
    return diag_winner if diag_winner

  end
  
  def prevent_two_corner_win
    board = Square.where(:board_id => self.id) 
    user_squares = board.select { |sq| sq.val == "X" }
    empty_squares = board.select { |sq| !sq.val }
    
    scenario1 = user_squares.select { |sq| (sq.x_value == 0 && sq.y_value == 0) || (sq.x_value == 2 && sq.y_value == 2) }
    scenario2 = user_squares.select { |sq| (sq.x_value == 2 && sq.y_value == 0) || (sq.x_value == 0 && sq.y_value == 2) }
    
    if user_squares.count == 2 && ( scenario1 || scenario2 )
      return empty_squares.find { |sq| sq.x_value == 1 && sq.y_value == 0 }
    end

  end
  
  def take_first_corner
    board = Square.where(:board_id => self.id) 
    empty_squares = board.select { |sq| !sq.val }
    return empty_squares.find { |sq| ( sq.x_value == 0 && sq.y_value == 0 ) || ( sq.x_value == 0 && sq.y_value == 2 ) || ( sq.x_value == 2 && sq.y_value == 0 ) || ( sq.x_value == 2 && sq.y_value == 2 )}
  end
  
  def take_first_side
    board = Square.where(:board_id => self.id) 
    empty_squares = board.select { |sq| !sq.val }
    return empty_squares.find { |sq| ( sq.x_value == 1 && sq.y_value == 0 ) || ( sq.x_value == 2 && sq.y_value == 1 ) || ( sq.x_value == 1 && sq.y_value == 2 ) || ( sq.x_value == 0 && sq.y_value == 2 )}
  end
  
  def diag_for(square)
    case
      when square.x_value == 2 && square.y_value == 0
        2
      when square.x_value == 0 && square.y_value == 2
        2
      when square.x_value == 0 && square.y_value == 0
        1
      when square.x_value == 2 && square.y_value == 2
        1
      when square.x_value == 1 && square.y_value == 1
        3
    end
  end

end
