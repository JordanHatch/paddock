class User < ApplicationRecord
  extend Enumerize

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  enumerize :role, in: %i[user admin], predicates: true

  scope :with_case_insensitive_email, ->(email) { where('LOWER(email) = ?', email.downcase) }
end
