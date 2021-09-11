class Message < ApplicationRecord
  validates :message, length: { maximum: 200 },
                      presence: true
  belongs_to :user
  belongs_to :room
end
