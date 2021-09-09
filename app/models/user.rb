class User < ApplicationRecord
  extend Enumerize

  enumerize :role, in: %i[user admin], predicates: true

  scope :with_case_insensitive_email, ->(email) { where('LOWER(email) = ?', email.downcase) }
end
