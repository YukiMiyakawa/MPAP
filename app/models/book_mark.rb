class BookMark < ApplicationRecord
  belongs_to :user
  belongs_to :main_post
end
