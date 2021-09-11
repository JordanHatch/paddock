class BaseService
  include Dry::Monads[:list, :result, :validated, :do]
  extend Forwardable

  attr_accessor :result

  def_delegators :result, :success?, :failure?

  def self.call(**args)
    new(**args).tap do |service|
      service.result = service.call
    end
  end

  def self.build(**args)
    new(**args).tap do |service|
      service.result = service.build
    end
  end

  def errors
    result.failure ? result.failure.to_a : []
  end
end
