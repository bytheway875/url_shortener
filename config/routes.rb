UrlShortener::Application.routes.draw do

  resources :urls

  get ':shortened_extension' => 'urls#redirect'

  root :to => 'urls#new'
end
