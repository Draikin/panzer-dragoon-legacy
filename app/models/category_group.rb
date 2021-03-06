class CategoryGroup < ActiveRecord::Base
  include Sluggable

  has_many :categories, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true

  # The list of category group types.
  CATEGORY_GROUP_TYPES = %w(
    article
    download
    encyclopaedia_entry
    music_track
    picture
    resource
    video
  ).freeze
end
