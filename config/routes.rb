Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :plans, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    post :invite_members, on: :member
    resources :checklist_items, only: [:index, :create, :update, :destroy] do
      patch :toggle, on: :member
    end
    resources :memory_folders do
      resources :memories, only: [:index, :create, :edit, :destroy]
    end
    resources :notes
    resources :chat_messages, only: [:index, :create, :destroy]
    resources :schedule_items
  end

  resources :plan_invitations, only: [] do
    get :accept, on: :member
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Action Cableのルーティング設定
  mount ActionCable.server => '/cable'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
