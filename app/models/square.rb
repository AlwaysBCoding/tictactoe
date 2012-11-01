class Square < ActiveRecord::Base
  attr_accessible :board_id, :val
  
  belongs_to :board
  
  def to_s
    val
  end
  
end
