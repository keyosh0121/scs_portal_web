Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/" => "home#top"

  post "login/send" => "user#login_user"
  get "login" => "user#login"
  post "signup/send" => "user#register"
  get "signup" => "user#new"

  get "user/:id/show" => "user#show"
  post "user/logout" => "user#logout"

  get "submit/mic" => "submit#mic"
  post "submit/mic/send" => "submit#mic_submit"
  post "submit/mic/destroy/:id" => "submit#mic_destroy"
    get "submit/mic-list" => "submit#mic_list"
  get "submit/comment" => "submit#comment"
  get "submit/comment/list" => "submit#comment_list"
  post "submit/comment/list/destroy/:id" => "submit#comment_destroy"
  get "submit/comment/conference" => "submit#comment_conference"
  post "submit/comment/conference/send" => "submit#comment_conference_send"
  post "submit/comment/conference/get_content" => "submit#get_content"
  get "submit/comment/performance" => "submit#comment_performance"
  post "submit/comment/performance/send" => "submit#comment_performance_send"

  post "submit/regular-band/send" => "submit#regular_band_submit"
  get "submit/regular-band" => "submit#regular_band"
  post "submit/temporal-band/send" => "submit#temporal_band_submit"
  get "submit/temporal-band" => "submit#temporal_band"
  get "submit/room" => "submit#room"
  post "submit/room/send" => "submit#room_send"
  get "submit/room/send" => "submit#room"

  get "/database/bands" => "admin#show_bands"
  post "/database/bands/register/:id" => "admin#register_band"
  get "/database/registered-bands" => "admin#show_registered_bands"
  get "database/temporal-bands" => "admin#show_temporal_bands"
  get "/database/show-event" => "admin#show_event"
  post "/database/add-event" => "admin#add_event"
  post "/database/event-delete/:id" => "admin#delete_event"
  get "/database/users" => "admin#show_users"
  post "/database/user/:user_id/approve" => "admin#user_approve"
  post "/database/users/authority_edit/:id" => "admin#user_authority_edit"
  get "/database/notifications" => "admin#show_infos"
  post "/database/notifications/new" => "admin#add_infos"
  get "/database/mic-practice" => "admin#show_mic"
  get "/database" => "admin#top"


end
