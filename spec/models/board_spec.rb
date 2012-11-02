require 'spec_helper'

describe Board do
  describe '#player_chance_to_win?' do
    it 'returns true for [1,1], [1,2]' do
      board = Board.create
      board.human_take_square(1,1)
      board.human_take_square(1,2)
      board.player_chance_to_win?.should == true
    end
    
    it 'returns true for [0,1], [0,0]' do
      board = Board.create
      board.human_take_square(0,1)
      board.human_take_square(0,0)
      board.player_chance_to_win?.should == true
    end
    
  end
  
  describe '#possible_winning_move' do
    it 'checks if [0,1] is blank' do
      board = Board.create
      board.human_take_square(1,1)
      board.human_take_square(1,2)
      board.possible_winning_move.should == Square.where(:board_id => board.id).where(:x_value => 1).where(:y_value => 0).first
    end
  end
end
