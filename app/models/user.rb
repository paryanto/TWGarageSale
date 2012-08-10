class User < ActiveRecord::Base
  has_many :bids, :inverse_of => :user

  devise :omniauthable
  attr_accessible :username, :admin
  validates :username, :presence => true, :length => { :maximum => 255 }

  # for dummy users
  devise :database_authenticatable
  attr_accessible :email, :password, :password_confirmation

  # Devise method used to create user from CAS uid
  def self.find_or_create_from_auth_hash(auth_hash, signed_in_resource=nil)
    return nil unless defined? auth_hash[:uid]
    return nil if auth_hash[:uid].blank?

    user = User.where(:username => auth_hash[:uid])

    return user.first unless user.empty?

    User.create!(:username => auth_hash[:uid], :admin => self.is_admin?(auth_hash[:uid]))
  end

  def self.is_admin?(uid)
    admins = ["dgower", "prtan", "twamazon"]
    if admins.include?(uid)
      true
    else
      false
    end
  end

  # This is commented out when still need test mode, which need password validation
  # for CAS, no need for password validation within system so should add this method
  #def valid_password?(password)
  #  true
  #end
end
