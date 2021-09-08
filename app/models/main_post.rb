class MainPost < ApplicationRecord
  attachment :image
  belongs_to :user
end
