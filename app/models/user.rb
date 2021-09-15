class User < ApplicationRecord
  #認証キーに[:name]追加
  devise :database_authenticatable, authentication_keys: [:name]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true

  attachment :image

  has_many :main_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :main_post
  has_many :tweets, dependent: :destroy
  has_many :user_music_genres, dependent: :destroy
  has_many :user_instruments, dependent: :destroy
  has_many :book_marks, dependent: :destroy
  has_many :tasks, dependent: :destroy

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
end