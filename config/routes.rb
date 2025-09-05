Rails.application.routes.draw do
  devise_for :models
  devise_for :admins
  devise_for :students
  devise_for :teachers

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "home#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")

  resources :departments
  resources :semesters
  resources :subjects
  resources :students

  namespace :api do
    get :subjects, to: "subjects#index"
    get :students, to: "students#index"
    get :students_with_attendance, to: "students#with_attendance"
    get :attendances, to: "attendances#index"
    get :existing_attendance, to: "attendances#existing_attendance"
    get :'attendance/summary', to: 'api#attendance_summary'
  end

  resources :attendances, only: [] do
    collection do
      get :bulk_show
      get :bulk_new
      get :bulk_view
      post :bulk_create
    end
  end

  #Admins
  resources :admins,only: [:index,:show, :new, :create, :edit, :update, :destroy]
  # Students
  resources :students, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Teachers
  resources :teachers, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Departments
  resources :departments, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Semesters
  resources :semesters, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Subjects
  resources :subjects, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
