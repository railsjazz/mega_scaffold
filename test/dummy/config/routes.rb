Rails.application.routes.draw do
  mega_scaffold :users

  root "home#index"
end
