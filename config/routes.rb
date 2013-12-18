draw do
  get "/" => 'user#root', "/user/(?<id>\\d+)" => 'user#show'
  post "/forms" => 'user#form'
  put "/puts" => 'user#puts'
end