class Square < ActiveRecord::Base
  attr_accessible :board_id, :val, :winner
  
  belongs_to :board
  belongs_to :player
  
  def to_s
    val
  end
  
end
