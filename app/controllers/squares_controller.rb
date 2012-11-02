class SquaresController < ApplicationController
  
  def update
    board = Board.find(params["board"].to_i)
    @human_square = Square.where(:board_id => board.id).where(:x_value => params["x_value"]).where(:y_value => params["y_value"]).first
    @human_square.val = "X"; @human_square.save!
    @computer_square = board.calculate_computer_move
    render "something.js.erb"
  end
  
end
