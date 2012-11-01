class Board < ActiveRecord::Base
  
  has_many :squares
  after_save :create_squares
  
  def create_squares
    9.times do |i|
      square = Square.new({
        :board_id => self.id,
        :val => nil
        })
        
      case i
        when 0..2
          square.y_value = 0  
        when 3..5
          square.y_value = 1
        when 6..8
          square.y_value = 2    
      end
      
      case
        when i % 3 == 0
          square.x_value = 0
        when i % 3 == 1
          square.x_value = 1
        when i % 3
          square.x_value = 2 
      end    
      
      square.save!
    end
  end

end
