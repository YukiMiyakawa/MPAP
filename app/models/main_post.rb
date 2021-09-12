class MainPost < ApplicationRecord
  mount_uploader :audio, AudioUploader
  attachment :image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :sub_posts, dependent: :destroy
  has_many :book_marks, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def book_mark_by?(user)
    book_marks.where(user_id: user.id).exists?
  end
end
