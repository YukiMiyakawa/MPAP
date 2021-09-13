class PostTag < ApplicationRecord
  belongs_to :main_post
  belongs_to :tag
end
