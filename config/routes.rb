Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  get '/sign-in', to: 'invitations#new', as: :new_invitation
  post '/sign-in', to: 'invitations#create', as: :invitation
  get '/sign-in/sent', to: 'invitations#sent', as: :sent_invitation
  get '/sign-in/:token', to: 'invitations#redeem', as: :redeem_invitation
  post '/sign-in/:token', to: 'invitations#do_redeem'
  post '/sign-out', to: 'invitations#sign_out', as: :sign_out

  get '/sprints', to: 'sprints#index', as: :sprints
  get '/sprints/:id', to: 'sprints#show', as: :sprint
  post '/sprints/:id/export', to: 'sprints#export', as: :export_sprint
  get '/sprints/:id/issues', to: 'sprints#issues', as: :sprint_issues

  get '/sprints/:sprint_id/:team_id', to: 'updates#show', as: :update
  patch '/sprints/:sprint_id/:team_id', to: 'updates#update'

  get '/sprints/:sprint_id/:team_id/history', to: 'updates#history', as: :history_update
  get '/sprints/:sprint_id/:team_id/submit', to: 'updates#submit', as: :submit_update
  post '/sprints/:sprint_id/:team_id/submit', to: 'updates#do_submit'
  post '/sprints/:sprint_id/:team_id/start', to: 'updates#start', as: :start_update

  get '/sprints/:sprint_id/:team_id/edit', to: 'updates#edit', as: :edit_update
  get '/sprints/:sprint_id/:team_id/:form', to: 'updates#edit', as: :edit_update_form

  scope module: 'quarters' do
    resources :quarters, controller: 'root', only: [:index, :show] do
      resources :commitments do
        member do
          get :history
        end
      end

      get '/commitments/:id/:form', to: 'commitments#edit', as: :commitment_form
    end
  end

  namespace :api do
    scope :v1, as: :v1 do
      get '/sprints', to: 'v1#sprints', as: :sprints
      get '/sprints/:id', to: 'v1#sprint', as: :sprint
      get '/sprint-updates', to: 'v1#sprint_updates', as: :sprint_updates
      get '/sprint-updates/:id', to: 'v1#sprint_update', as: :sprint_update
      get '/teams', to: 'v1#teams', as: :teams
      get '/teams/:id', to: 'v1#team', as: :team
    end
  end

  namespace :manage do
    resources :sprints

    resources :sprint_updates, path: '/sprints/:sprint_id',
                               except: [:index, :new, :create], param: :team_id do
      member do
        post :unpublish
      end
    end
    resources :teams

    resources :quarters do
      member do
        get :reorder_commitments, path: 'reorder-commitments'
        patch :do_reorder_commitments, path: 'reorder-commitments'
      end
    end

    root to: 'root#index'
  end

  if Rails.env.development?
    get '/development/:view', to: 'development/static#show'
  end

  root to: redirect('/sprints')
end
