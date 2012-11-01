class PagesController < ApplicationController
  def board
    @board = Board.create
    @player = Player.create({:species => "human"})
    @computer = Player.create({:species => "computer"})
  end
end
