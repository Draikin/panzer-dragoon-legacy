class Picture < ApplicationRecord
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Relatable
  include Syncable

  belongs_to :album

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file(
    :picture,
    styles: {
      mini_thumbnail: '75x75#',
      news_entry_thumbnail: '100x100#',
      thumbnail: '150x150>',
      triple_thumbnail: '150x150#',
      double_thumbnail: '238x238#',
      single_thumbnail: '486x486>',
      embedded: '625x625>'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :picture,
    presence: true,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_validation :validate_category_and_album_category_match
  before_save :sync_file_name
  before_save :replace_picture

  def sync_file_name
    sync_file_name_of :picture, file_name: "#{name.to_url}.jpg"
  end

  def to_param
    id.to_s + '-' + url
  end

  def name_and_id
    "#{name} (#{id})"
  end

  private

  def validate_category_and_album_category_match
    if album.present?
      if album.category != category
        errors.add(:category, 'does not match the category of the ' \
          "picture's album.")
      end
    end
  end

  def replace_picture
    if publish && id_of_picture_to_replace.present?
      picture_to_replace = Picture.find(id_of_picture_to_replace)
      picture_to_replace.destroy
    end
  end
end
