class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 20, minimum: 2 }, uniqueness: true
  validates :introduction, length: {maximum: 50}
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed # 自分がフォローしている人
  has_many :followers, through: :passive_relationships, source: :follower # 自分をフォローしている人

  has_one_attached :profile_image

  has_many :massages, dependent: :destroy
  has_many :entries, dependent: :destroy

  # ユーザーをフォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user_id)
    followings.include?(user_id)
  end

  def get_profile_image(width, height)
    if !profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    return profile_image.variant(resize: "#{width}x#{height}").processed
  end
end
