class Features
  FEATURES = [
    :export_uploads
  ]

  def self.enabled?(feature, user)
    raise "#{feature} not found" unless FEATURES.include?(feature)
    return true if Rails.env.development? or Rails.env.test?

    env_var = "feature_#{feature.to_s}_users".upcase

    user_ids = ENV.fetch(env_var, '').split(',')
    user_ids.include?(user.id.to_s)
  end
end
