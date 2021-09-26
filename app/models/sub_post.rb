class SubPost < ApplicationRecord
  validates :title, length: { minimum: 1, maximum: 80 }, presence: true
  validates :content, length: { minimum: 1, maximum: 30000 }, presence: true
  mount_uploader :audio, AudioUploader
  attachment :image
  belongs_to :main_post

  # ファイル形式バリデーション
  validate :check_audio

  def check_audio
    if audio.filename
      pp audio.file.file
      if !['.mp3'].include?(File.extname(audio.filename).downcase)
          errors.add(:audio, "mp3のみアップロードできます。")
      elsif File.size(audio.file.file) > 30.megabyte
          errors.add(:audio, "30MBまでアップロードできます")
      end
    end
  end

  def check_image(name)
  pp image
    if !['.jpg', '.png', '.gif'].include?(File.extname(name).downcase)
        errors.add(:image, "JPG, PNG, GIFのみアップロードできます。")
    end
  end
end
