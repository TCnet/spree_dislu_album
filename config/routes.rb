Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :dislu_albums
    resources :dislu_imports do
      member do
        post :importdata
      end
    end
    resources :dislu_templates 

  end
end
