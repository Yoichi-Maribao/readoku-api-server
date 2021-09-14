class Book < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  is_impressionable

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: (Time.current.at_end_of_day - 6.day).at_beginning_of_day...Time.current.at_end_of_day)}
  scope :created_last_week, -> { where(created_at: (Time.current.at_end_of_day - 13.day).at_beginning_of_day...(Time.current.at_end_of_day - 7.day).at_end_of_day)}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
