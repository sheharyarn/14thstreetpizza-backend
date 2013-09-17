FourteenStreetPizza::Application.routes.draw do
  devise_for :users, :skip => [:registrations, :sessions, :passwords]
  
  root :to                             => 'application#comingsoon'
  match '/404/'                        => 'application#not_found',  :via => :GET
  match '/500/'                        => 'application#exception',  :via => :GET

  namespace :api, defaults: {format: 'json'} do
    root :to                           => 'api#null'
    match '/test/'                     => 'api#test',               :via => :GET
    
    namespace :v1 do
      root :to                         => 'v1#index'

      match '/me/'                     => 'user#index',             :via => :GET
      match '/me/area/'                => 'user#area_status',       :via => :GET
      match '/me/notifications/'       => 'user#notifications',     :via => :GET
      match '/me/session/'             => 'user#validsession',      :via => :GET
      match '/me/logout/'              => 'user#logout',            :via => :GET
      match '/me/login/'               => 'user#login',             :via => :POST
      match '/me/coordinates/'         => 'user#coordinates',       :via => :POST

      match '/situation/new/'          => 'status#new',             :via => :POST
      match '/situation/:id/'          => 'status#show',            :via => :GET
      match '/situation/:id/'          => 'status#delete',          :via => :DELETE
      match '/situation/:id/edit/'     => 'status#edit',            :via => :PUT
      match '/situation/:id/vote/'     => 'status#vote',            :via => :POST
      match '/situation/:id/comment/'  => 'status#comment',         :via => :POST
    end

    # namespace :v2 do
    # end
  end 
end
