# @label User name
class Common::UserNameComponentPreview < ViewComponent::Preview
  # @group

  # @label User with name
  # ----------------
  #
  def user_with_name
    render Common::UserNameComponent.new(user: User.new(name: 'Winston Smith-Churchill',
                                                email: 'winston@paddock.dev'))
  end

  # @label User without a name
  # ----------------
  #
  def user_with_no_name
    render Common::UserNameComponent.new(user: User.new(email: 'winston@paddock.dev'))
  end

  # @endgroup
end
