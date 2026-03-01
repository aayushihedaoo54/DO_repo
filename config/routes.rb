require 'sidekiq/web'

Rails.application.routes.draw do
  post  "/jobs", to: "jobs#create"
  get "/health/detailed", to: "health#detailed"
end
