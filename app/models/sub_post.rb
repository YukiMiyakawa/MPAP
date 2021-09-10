class SubPost < ApplicationRecord
  attachment :image
  belongs_to :main_post

end
