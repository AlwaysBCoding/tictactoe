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
    
    # Make Second Move
    possible_winning_square = possible_winning_move(human_square)
    return computer_take_square(possible_winning_square.x_value, possible_winning_square.y_value) if possible_winning_square
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

  def possible_winning_move(human_square)
    #player_sq_array = Square.where(:board_id => self.id).where('val NOT NULL')#.map { |sq| [sq.x_value, sq.y_value, sq.val] } 
    board = Square.where(:board_id => self.id) 
    empty_squares = board.select { |sq| !sq.val }
    player_moves_in_current_column = board.select { |sq| sq.val == "X" && sq.x_value == human_square.x_value }
    empty_squares.find { |sq| sq.x_value == human_square.x_value } if player_moves_in_current_column.count == 2
  end
  
  def block_player
  end

end
