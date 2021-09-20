class User < ApplicationRecord
  #認証キー追加
  devise :database_authenticatable, authentication_keys: [:name, :target_time, :introduction]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, length: { minimum: 1, maximum: 20 }, presence: true
  validates :introduction, length: { minimum: 1, maximum: 80 }, presence: true
  validates :target_time, presence: true, numericality: { only_integer: true }

  attachment :image

  # 記事
  has_many :main_posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # いいね
  has_many :favorites, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :main_post

  # つぶやき
  has_many :tweets, dependent: :destroy

  # 自分の得意音楽ジャンル、楽器
  has_many :user_music_genres, dependent: :destroy
  has_many :user_instruments, dependent: :destroy

  # ブックマーク
  has_many :book_marks, dependent: :destroy

  # 練習項目
  has_many :tasks, dependent: :destroy

  # DM機能
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy


  #フォロー機能
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :followings, through: :relationships, source: :followed

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # 期間毎の練習時間算出
  def microposts_period(period)
    current = Time.current.beginning_of_day
    case period
    when "week"
      start_date = current.ago(6.days)
    when "month"
      start_date = current.ago(1.month - 1.day)
    when "year"
      start_date = current.ago(1.year - 1.day)
    else
      start_date = current.ago(6.days)
    end
    end_date = Time.current
    dates = {}
    (start_date.to_datetime...end_date.to_datetime).each do |date|
      tweets = self.tweets.where(created_at: date.beginning_of_day...date.end_of_day)
      sum_times = tweets.sum(:practice_time)
      dates.store(date.to_date.to_s, sum_times)
    end
    return dates
  end

  # 通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # フォロー時通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end