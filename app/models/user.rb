# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_reader :password

  validates :username, :session_token, :password_digest, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many(
    :subs,
    class_name: :Sub,
    foreign_key: :moderator_id,
    primary_key: :id
  )

  has_many(
    :posts,
    class_name: :Post,
    foreign_key: :author_id,
    primary_key: :id
  )

  def self.generate_session_token
    SecureRandom.base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    save!

    session_token
  end

end
