class Article < ApplicationRecord
  include Categorisable
  include Contributable
  include Illustratable
  include Relatable
  include Sluggable

  validates :name, presence: true, uniqueness: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }
  validates :content, presence: true
end
