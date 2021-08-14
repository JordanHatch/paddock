class BaseService
  extend Enumerize

  class Failure < StandardError; end

  enumerize :state, in: %i[success failure], predicates: true

  def self.call(**args)
    new(**args).tap(&:call)
  end

  def set_state(state)
    self.state = state
  end
end
