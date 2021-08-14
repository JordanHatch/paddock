Rails.application.routes.draw do
  get '/sign-in', to: 'invitations#new', as: :new_invitation
  post '/sign-in', to: 'invitations#create', as: :invitation
  get '/sign-in/sent', to: 'invitations#sent', as: :sent_invitation
  get '/sign-in/:token', to: 'invitations#redeem', as: :redeem_invitation
  post '/sign-in/:token', to: 'invitations#do_redeem'
  post '/sign-out', to: 'invitations#sign_out', as: :sign_out

  get '/sprints', to: 'sprints#index', as: :sprints
  get '/sprints/:id', to: 'sprints#show', as: :sprint
  post '/sprints/:id/export', to: 'sprints#export', as: :export_sprint

  get '/sprints/:sprint_id/:team_id', to: 'updates#show', as: :update
  patch '/sprints/:sprint_id/:team_id', to: 'updates#update'

  get '/sprints/:sprint_id/:team_id/history', to: 'updates#history', as: :history_update
  get '/sprints/:sprint_id/:team_id/submit', to: 'updates#submit', as: :submit_update
  post '/sprints/:sprint_id/:team_id/submit', to: 'updates#do_submit'
  post '/sprints/:sprint_id/:team_id/start', to: 'updates#start', as: :start_update

  get '/sprints/:sprint_id/:team_id/edit', to: 'updates#edit', as: :edit_update
  get '/sprints/:sprint_id/:team_id/:form', to: 'updates#edit', as: :edit_update_form

  namespace :manage do
    resources :sprints
    resources :teams

    root to: 'root#index'
  end

  root to: redirect('/sprints')
end
