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
    admin:  "admin",
    parent: "parent",
    child:  "child"
  }
end
