module BaseForm::Hooks
  extend ActiveSupport::Concern

  HOOKS = %i[
    preprocess
    before_validate
  ]

  module ClassMethods
    attr_reader :blocks

    HOOKS.each do |hook|
      define_method(hook) do |&block|
        @blocks ||= {}
        @blocks[hook] = block
      end
    end

    def trigger_hook(hook, *args)
      @blocks ||= {}
      return if @blocks[hook].blank?

      @blocks[hook].call(*args)
    end
  end
end
