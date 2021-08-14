class BaseService
  extend Enumerize

  class Failure < StandardError; end

  enumerize :state, in: [:success, :failure], predicates: true

  def self.call(**args)
    self.new(**args).tap(&:call)
  end

  def set_state(state)
    self.state = state
  end
end
