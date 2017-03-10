class User < ApplicationRecord
  include Clearance::User

  enum age_range: ["0-18", "19-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"]

  validates :stamina, :strength, :agility, inclusion: { in: [nil, 1, 2, 3, 4, 5], message: "invalid values." }

  has_many :authentications
  has_many :pendings
  has_many :confirmed_activities
  has_many :messages

  mount_uploader :avatar, AvatarUploader
  
  def self.create_with_auth_and_hash(authentication, auth_hash)
    def password_optional?
      true
    end

    user = User.create!(name: auth_hash["name"], email: auth_hash["extra"]["raw_info"]["email"])
    user.authentications << (authentication)

    def password_optional?
      true
    end
    return user
  end

  def fb_token
    x = self.authentications.where(:provider => :facebook).first
    return x.token unless x.nil?
  end

<<<<<<< HEAD
  def has_nil_attributes
    !self.encrypted_password || !self.name || !self.city || !self.state || !self.country || !self.age_range || !self.strength || !self.stamina || !self.agility
  end

  def has_no_password
    if self.encrypted_password == nil
      return true
    else
      return false
    end
  end
=======
>>>>>>> 8385b2b140ef0c8f9a2589474d53bcfbd75fd729
end
