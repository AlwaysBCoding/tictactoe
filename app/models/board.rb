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
  
    possible_winning_square = winning_move
    return computer_take_square(possible_winning_square.x_value, possible_winning_square.y_value) if possible_winning_square
    
    possible_blocking_square = blocking_move(human_square)
    return computer_take_square(possible_blocking_square.x_value, possible_blocking_square.y_value) if possible_blocking_square
  end
  
  def human_take_square(x,y)
    square = Square.where(:board_id => self.id).where(:x_value => x).where(:y_value => y).first
    square.update_attributes(:val => "X")
    return square
  end
  
  def computer_take_square(x,y)
    square = Square.where(:board_id => self.id).where(:x_value => x).where(:y_value => y).first
    square.val = "O"; square.save!
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
    
    computer_moves_in_top_row = board.select { |sq| sq.val == "O" && sq.y_value == 0 }
    top_row_winner = empty_squares.find { |sq| sq.y_value == 0 } if computer_moves_in_top_row.count == 2
    return top_row_winner if top_row_winner
    
  end

  def blocking_move(human_square)
    #player_sq_array = Square.where(:board_id => self.id).where('val NOT NULL')#.map { |sq| [sq.x_value, sq.y_value, sq.val] } 
    board = Square.where(:board_id => self.id) 
    empty_squares = board.select { |sq| !sq.val }
    
    player_moves_in_current_column = board.select { |sq| sq.val == "X" && sq.x_value == human_square.x_value }
    column_winner = empty_squares.find { |sq| sq.x_value == human_square.x_value } if player_moves_in_current_column.count == 2
    return column_winner if column_winner
    
    player_moves_in_current_row = board.select { |sq| sq.val == "X" && sq.y_value == human_square.y_value }
    row_winner = empty_squares.find { |sq| sq.y_value == human_square.y_value } if player_moves_in_current_row.count == 2
    return row_winner if row_winner
    
    player_moves_in_current_diag = board.select { |sq| sq.val == "X" && diag_for(sq) == diag_for(human_square) }
    diag_winner = empty_squares.find { |sq| diag_for(sq) == diag_for(human_square) } if player_moves_in_current_diag.count == 2
    return diag_winner if diag_winner
  end
  
  def diag_for(square)
    case
      when square.x_value == 2 && square.y_value == 0
        2
      when square.x_value == 1 && square.y_value == 1
        2
      when square.x_value == 0 && square.y_value == 2
        2
      when square.x_value == 0 && square.y_value == 0
        1
    end
  end
  
  def block_player
  end

end
