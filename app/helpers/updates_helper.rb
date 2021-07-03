module UpdatesHelper
  def change_history_user(user_id)
    (User.where(id: user_id).first || User.new).email
  end
end
