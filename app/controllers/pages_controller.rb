class PagesController < ApplicationController
  def board
    @board = Board.create
  end
end
