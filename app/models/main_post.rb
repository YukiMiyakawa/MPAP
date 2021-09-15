class MainPost < ApplicationRecord
  mount_uploader :audio, AudioUploader
  attachment :image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :sub_posts, dependent: :destroy
  has_many :book_marks, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def book_mark_by?(user)
    book_marks.where(user_id: user.id).exists?
  end

  #タグ機能
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  def save_tag(sent_tags)
    current_tags = tags.pluck(:name) unless tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_request_tag = Tag.find_or_create_by(name: new)
      tags << new_request_tag
    end
  end

  # main_posts_indexソート機能
  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'old'
      return all.order(created_at: :ASC)
    when 'likes'
      return includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    when 'dislikes'
      return includes(:favorited_users).sort {|a,b| a.favorited_users.size <=> b.favorited_users.size}
    end
  end
end
