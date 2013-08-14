class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable
  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  has_many :tasks

  def as_json(options = {})
    {
        id: id,
        name: name,
        email: email,
        created_at: created_at,
        updated_at: updated_at,
        auth_token: authentication_token
    }
  end
end
