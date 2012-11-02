require 'spec_helper'

describe Board do
  describe '#blocking_move' do
    it 'returns the blank square for [1,1], [1,2] ' do
      board = Board.create
      board.human_take_square(1,1)
      human_square = board.human_take_square(1,2)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 1).where(:y_value => 0).first
    end
    
    it 'returns the blank square for [0,1], [0,2] ' do
      board = Board.create
      board.human_take_square(0,1)
      human_square = board.human_take_square(0,2)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 0).first
    end
    
    it 'returns the blank square for [0,0], [1,0] ' do
      board = Board.create
      board.human_take_square(0,0)
      human_square = board.human_take_square(1,0)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 2).where(:y_value => 0).first
    end
    
    it 'returns the blank square for [1,1], [2,0] ' do
      board = Board.create
      board.human_take_square(1,1)
      human_square = board.human_take_square(2,0)
      board.blocking_move(human_square).should == Square.where(:board_id => board.id).where(:x_value => 0).where(:y_value => 2).first
    end

  end

end
