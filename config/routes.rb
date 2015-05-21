Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :shipwire, only: [:show] do
      post 'enable/:topic', to: 'shipwires#enable', as: :enable
      post 'disable/:topic', to: 'shipwires#disable', as: :disable

      post 'secret/create', to: 'shipwires#secret_create', as: :create_secret
      post 'secret/remove', to: 'shipwires#secret_remove', as: :remove_secret
    end
  end
end
