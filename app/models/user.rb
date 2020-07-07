class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:atlassian_oauth2]


  def self.from_omniauth(auth)
    user = User.where(provider: auth.try(:provider) || auth["provider"], uid: auth.try(:uid) || auth["uid"]).first
    if user
      return user
    else
      registered_user = User.where(provider: auth.try(:provider) || auth["provider"], uid: auth.try(:uid) || auth["uid"]).first || User.where(email: auth.try(:info).try(:email) || auth["info"]["email"]).first
      if registered_user
        unless registered_user.provider == (auth.try(:provider) || auth["provider"]) && registered_user.uid == (auth.try(:uid) || auth["provider"])
          registered_user.update_attributes(provider: auth.try(:provider) || auth["provider"], uid: auth.try(:uid) || auth["uid"])
        end
        return registered_user
      else
        user = User.new(provider: auth.try(:provider) || auth["provider"], uid: auth.try(:uid) || auth["uid"])
        user.email = auth.try(:info).try(:email) || auth["info"]["email"]
        user.password = Devise.friendly_token[0,20]
        puts auth["info"]
        user.save(validate: false)
      end
      user
    end
  end
end
