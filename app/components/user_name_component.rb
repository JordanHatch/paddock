# frozen_string_literal: true

class UserNameComponent < BaseComponent
  option :user

  private

  def render?
    user.present?
  end

  def name
    user.name
  end

  def name_present?
    name.present?
  end

  def email
    user.email
  end
end
