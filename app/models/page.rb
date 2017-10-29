class Page < ApplicationRecord
  include Sluggable
  include Illustratable

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :content, presence: true
end
