Rails.application.routes.draw do
  root 'welcome#index'

  resources :submissions, except: [:index, :new, :show, :edit]
  resources :users
  resources :invites

  resources :courses do
    resources :teams
    resources :assignments, shallow: true
  end

  get 'courses', to: 'courses#index'
  get '/submissions/:id/test', to: 'submissions#test', as: 'test'
  post '/assignments/:id/process_submissions', to: 'assignments#process_submissions', as: 'process_submissions'
  get '/assignments/:id/submission_repo_sha', to: 'assignments#submission_repo_sha', as: 'submission_repo_sha'
  get '/courses/:id/publish', to: 'courses#publish', as: 'publish'
  get '/courses/:id/students', to: 'courses#students', as: 'students'
  get '/courses/:id/instructors', to: 'courses#instructors', as: 'instructors'
  patch '/courses/:id/import_students_csv', to: 'courses#import_students_csv', as: 'import_students_csv'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
