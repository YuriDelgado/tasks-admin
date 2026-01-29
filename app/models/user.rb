class User < ApplicationRecord
  belongs_to :account

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  enum :role, {
    child:  "child",
    parent: "parent",
    admin:  "admin",
    system: "system"
  }

  def manager?
    parent? || admin? || system?
  end
end
