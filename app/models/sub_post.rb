class SubPost < ApplicationRecord
  mount_uploader :audio, AudioUploader
  attachment :image
  belongs_to :main_post

end
