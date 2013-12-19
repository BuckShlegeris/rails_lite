draw do
  get "/cats/(?<id>\\d+)" => 'cats#show'
  get "/cats" => 'cats#index'
  get "/cats/new" => 'cats#new'
  post "/cats" => 'cats#create'
  get "/" => 'cats#index'
end