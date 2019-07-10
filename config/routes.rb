Rails.application.routes.draw do
  root to: 'short_links#new'

  resources :short_links, only: [:new, :create, :show, :update]
  get 's/:short_url', to: 'short_links#index'
  get 'admin/:id', to: 'short_links#edit', as: :admin
end
