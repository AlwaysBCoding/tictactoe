Tictactoe::Application.routes.draw do

root :to => "pages#board"

post "/squares" => "squares#update", :as => "squares"

end
