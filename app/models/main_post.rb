class MainPost < ApplicationRecord
  validates :title, length: { minimum: 1, maximum: 80 }, presence: true
  validates :content, length: { minimum: 1, maximum: 30000 }, presence: true

  mount_uploader :audio, AudioUploader
  attachment :image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :sub_posts, dependent: :destroy
  has_many :book_marks, dependent: :destroy

  # 通知
  has_many :notifications, dependent: :destroy

  # いいね
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  # いいねがされているかどうか
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def book_mark_by?(user)
    book_marks.where(user_id: user.id).exists?
  end

  #タグ機能
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  #タグ編集
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

  # main_posts_indexソート機能(クラス)
  def self.post_sort(selection)
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

  # いいね通知
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and main_post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        main_post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメント通知
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(main_post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  # コメント通知
  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      main_post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
