draw do
  get "/" => 'user#root'
  get "/user/(?<id>\\d+)" => 'user#show'
  post "/forms" => 'user#form'
  put "/puts" => 'user#puts'
end