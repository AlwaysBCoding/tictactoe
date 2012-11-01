class Player < ActiveRecord::Base
  attr_accessible :species
  
  has_many :squares
end
