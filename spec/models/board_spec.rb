require 'spec_helper'

describe Board do
  describe '#blocking_move' do
    it 'returns the vertical center block for [1,1], [1,2] ' do
      board = Board.create
      board.human_take_square(1,1)
      human_square = board.human_take_square(1,2)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 1).where(:y_value => 0).first
    end
    
    it 'returns the horizontal block for [0,1], [0,2] ' do
      board = Board.create
      board.human_take_square(0,1)
      human_square = board.human_take_square(0,2)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 0).first
    end
    
    it 'returns the vertical left block for [0,0], [1,0] ' do
      board = Board.create
      board.human_take_square(0,0)
      human_square = board.human_take_square(1,0)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 0).first
    end
    
    it 'returns the diag 2 block for [1,1], [2,0] ' do
      board = Board.create
      board.human_take_square(1,1)
      human_square = board.human_take_square(2,0)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 2).first
    end

  end
  
  describe '#calculate_computer_move' do
    it 'takes the winning move for [1,1], [1,2], [0,1] ' do
      board = Board.create
      board.human_take_square(1,1)
      board.computer_take_square(0,0)
      board.human_take_square(1,2)
      board.computer_take_square(1,0)
      human_square = board.human_take_square(0,1)
      computer_move = board.calculate_computer_move(human_square)
      
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 0).first
      computer_move.should be_winner
    end
    
    it 'takes the winning move for [1,0], [1,2], [2,0] ' do
      board = Board.create
      board.human_take_square(1,0)
      board.computer_take_square(1,1)
      board.human_take_square(1,2)
      board.computer_take_square(0,1)
      human_square = board.human_take_square(2,0)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 1).first
      computer_move.should be_winner
    end
    
    it 'takes the winning move for [1,1], [2,1], [2,0] ' do
      board = Board.create
      board.human_take_square(1,1)
      board.computer_take_square(0,0)
      board.human_take_square(2,1)
      board.computer_take_square(0,1)
      human_square = board.human_take_square(2,0)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 2).first
      computer_move.should be_winner
    end
    
    it 'takes the diag winning move in isolation' do
      board = Board.create
      board.computer_take_square(0,0)
      board.computer_take_square(1,1)
      
      human_square = board.human_take_square(0,1)
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 2).first
      computer_move.should be_winner
    end
    
    it 'takes the diag winning move for [0,1], [0,2], [1,0]' do
      board = Board.create
      board.human_take_square(0,1)
      board.computer_take_square(1,1)
      board.human_take_square(0,2)
      board.computer_take_square(0,0)
      human_square = board.human_take_square(1,0)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 2).first
      computer_move.should be_winner
    end
    
    it 'takes the first available corner for [0,1], [1,2], [2,1]' do
      board = Board.create
      board.human_take_square(0,1)
      board.computer_take_square(1,1)
      board.human_take_square(1,2)
      board.computer_take_square(1,0)
      human_square = board.human_take_square(2,1)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 0).first
    end
    
    it 'takes the first available side for [0,0], [2,2], [0,2], [2,1]' do
      board = Board.create
      board.human_take_square(0,0)
      board.computer_take_square(1,1)
      board.human_take_square(2,2)
      board.computer_take_square(2,0)
      board.human_take_square(0,2)
      board.computer_take_square(0,1)
      human_square = board.human_take_square(2,1)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 1).where(:y_value => 0).first
    end
    
    it "doesn't try to block on the second move [0,1], [1,0]" do
      board = Board.create
      board.human_take_square(0,1)
      board.computer_take_square(1,1)
      human_square = board.human_take_square(1,0)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 0).first
    end
    
    it "takes a side when a user takes two corners [0,0], [2,2]" do
      board = Board.create
      board.human_take_square(0,0)
      board.computer_take_square(1,1)
      human_square = board.human_take_square(2,2)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 1).where(:y_value => 0).first
    end
    
    it "takes the top left corner at [0,1], [2,0]" do
      board = Board.create
      board.human_take_square(0,1)
      board.computer_take_square(1,1)
      human_square = board.human_take_square(1,2)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 0).first
    end
    
    it "takes the bottom right corner at [1,2], [2,1]" do
      board = Board.create
      board.human_take_square(1,2)
      board.computer_take_square(1,1)
      human_square = board.human_take_square(2,1)
      
      computer_move = board.calculate_computer_move(human_square)
      computer_move.should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 2).first
      
    end
    
    
  end

end
