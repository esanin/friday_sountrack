FridaySoundtrack::Application.routes.draw do


  put 'add_video', to: 'playlist#add_video', as: :add_video  
  root to: 'playlist#index'

end
