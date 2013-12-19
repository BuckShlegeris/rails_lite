draw do
  get "/cats/(?<id>\\d+)" => 'cats#show'
  get "/cats" => 'cats#index'
  get "/cats/new" => 'cats#new'
  post "/cats" => 'cats#create'
  delete "/cats/(?<id>\\d+)" => 'cats#delete'
  get "/" => 'cats#index'
end