class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) } # rubocop:disable all
  belongs_to :main_post, optional: true
  belongs_to :comment, optional: true
  belongs_to :room, optional: true

  belongs_to :visitor, class_name: 'User', optional: true
  belongs_to :visited, class_name: 'User', optional: true
end
