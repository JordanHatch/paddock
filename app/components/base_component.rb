class BaseComponent < ViewComponent::Base
  extend Dry::Initializer

  # A fix for using the .with_collection feature of view_component
  # whilst using dry-initializers
  #
  # https://github.com/github/view_component/issues/639#issuecomment-816969723
  #
  def self.initialize_parameters
    options = dry_initializer.options

    if options.empty?
      super
    else
      options.map { |option| [:keyreq, option.source] }
    end
  end
end
