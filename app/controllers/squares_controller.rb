class SquaresController < ApplicationController
  
  def update
    @square = Square.where(:board_id => params["board"]).where(:x_value => params["x_value"]).where(:y_value => params["y_value"]).first
    @square.val = "X"; @square.save!
    
    render "something.js.erb"
  end
end
