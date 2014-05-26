Listofgifs::Application.routes.draw do
  root :to => 'gifs#index'
  resources :gifs do
    collection do
      get :import
      get :random
      get :nsfw
    end
  end

  resources :unpublished_gifs do
    member do
      get :share
    end
    collection do
      get :nsfw
      delete :empty_trash
      delete :delete_all
    end
  end

  resources :gif_search_results, only: :index

  get '/sitemap', to: 'sitemap#index', defaults: { format: 'xml' }

  get '/channel.html' => proc {
    [
      200,
      {
        'Pragma'        => 'public',
        'Cache-Control' => "max-age=#{1.year.to_i}",
        'Expires'       => 1.year.from_now.to_s(:rfc822),
        'Content-Type'  => 'text/html'
      },
      ['<script src="//connect.facebook.net/en_US/all.js"></script>']
    ]
  }
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
end
