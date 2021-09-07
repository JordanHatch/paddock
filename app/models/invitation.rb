class Invitation < ApplicationRecord
  before_validation :set_token, :set_expires_at, :convert_email_to_lowercase

  scope :active, -> { where('expires_at > ?', Time.now) }

  validates :email, presence: true
  validate :email_has_permitted_domain

  def redeem
    return false if expires_at <= Time.now

    destroy
  end

  def set_token
    self.token = SecureRandom.hex(32)
  end

  def set_expires_at
    self.expires_at = 30.minutes.from_now
  end

  def email_has_permitted_domain
    return if email.blank?

    domain = email.match(/@([A-Za-z0-9\-.]+)\Z/) do |matches|
      matches[1]
    end

    domain_list = Paddock.permitted_domains.split(';')

    errors.add(:email, 'must be a permitted email') unless domain_list.include?(domain)
  end

  def convert_email_to_lowercase
    return if email.blank?
    self.email = email.downcase
  end
end
