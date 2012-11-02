class SquaresController < ApplicationController
  
  def update
    board = Board.find(params["board"].to_i)
    @human_square = board.human_take_square(params["x_value"], params["y_value"])
    @human_square.val = "X"; @human_square.save!
    @computer_square = board.calculate_computer_move
    render "something"
  end
  
end
