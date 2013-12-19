draw do
  resources :cats

  get "/" => 'cats#index'
end