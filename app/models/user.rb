class User < ApplicationRecord
  extend Enumerize

  enumerize :role, in: %i[user admin], predicates: true
end
