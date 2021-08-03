class Invitation < ApplicationRecord
  before_validation :set_token, :set_expires_at

  scope :active, -> { where('expires_at > ?', Time.now) }

  validates :email, presence: true
  validate :email_has_permitted_domain

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

  def email_has_permitted_domain
    return if email.blank?

    domain = email.match(/@([A-Za-z0-9\-\.]+)\Z/) {|matches|
      matches[1]
    }

    domain_list = Paddock.permitted_domains.split(';')

    unless domain_list.include?(domain)
      errors.add(:email, "must be a permitted email")
    end
  end
end
