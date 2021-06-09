Rails.application.routes.draw do
  root "application#goodBye"

  get "static_pages/home"
  get "static_pages/help"
end
