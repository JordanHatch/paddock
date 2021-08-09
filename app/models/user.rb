class User < ApplicationRecord
  extend Enumerize

  enumerize :role, in: [:user, :admin], predicates: true
end
