class Invitation < ApplicationRecord
  before_validation :set_token, :set_expires_at

  scope :active, -> { where('expires_at > ?', Time.now) }

  validates :email, format: { with: /\@(awe\.gov\.au)\z/ }

  def redeem
    return false if expires_at <= Time.now
    self.destroy
  end

  def set_token
    self.token = SecureRandom.hex(32)
  end

  def set_expires_at
    self.expires_at = 30.minutes.from_now
  end
end
