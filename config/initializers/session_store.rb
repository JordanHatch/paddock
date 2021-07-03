Rails.application.config.session_store :cookie_store,
  :key => '_paddock_session',
  :expire_after => 14.days
