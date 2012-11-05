class SquaresController < ApplicationController
  
  def update
    board = Board.find(params["board"].to_i)
    @human_square = board.human_take_square(params["x_value"], params["y_value"])
    @computer_square = board.calculate_computer_move(@human_square)
    render "response"
  end
  
end
