class NewsEntry < ApplicationRecord
  include Sluggable
  include Syncable

  belongs_to :contributor_profile

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :content, presence: true
  validates :contributor_profile, presence: true

  has_attached_file(
    :news_entry_picture,
    styles: {
      embedded: '622x250#'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :news_entry_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_save :publish_news_entry
  before_save :sync_file_name

  private

  def publish_news_entry
    # The first time the news entry is published:
    if published_at.blank? && publish
      publish_to_twitter

      # Set published_at field in the database to the current datetime:
      self.published_at = DateTime.now.utc
    end
  end

  def publish_to_twitter
    # Ensure that tweets aren't posted to Twitter when running RSpec:
    twitter_client.update generate_tweet if Rails.env == 'production'
  end

  def generate_tweet
    full_url = "http://www.panzerdragoonlegacy.com/news/#{url}"
    return "#{name} #{full_url}" if name[-1] == '?' || name[-1] == '!'
    "#{name}: #{full_url}"
  end

  def twitter_client
    twitter_client =
      Twitter::REST::Client.new do |config|
        config.consumer_key = Rails.application.secrets.twitter['consumer_key']
        config.consumer_secret =
          Rails.application.secrets.twitter['consumer_secret']
        config.access_token = Rails.application.secrets.twitter['oauth_token']
        config.access_token_secret =
          Rails.application.secrets.twitter['oauth_token_secret']
      end
    twitter_client
  end

  def sync_file_name
    if valid?
      sync_file_name_of(
        :news_entry_picture,
        file_name: "#{name.to_url}.jpg"
      )
    end
  end
end
