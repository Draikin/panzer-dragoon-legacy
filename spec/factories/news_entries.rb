FactoryGirl.define do
  factory :news_entry do
    factory :valid_news_entry do
      sequence(:name) { |n| "News Entry #{n}" }
      content 'Test Content'
      news_entry_picture Rack::Test::UploadedFile.new(
        'spec/fixtures/news-entry-picture.jpg', 'image/jpeg'
      )

      category { FactoryGirl.create(:valid_category) }
      contributor_profile { FactoryGirl.create(:valid_contributor_profile) }

      factory :published_news_entry do
        publish true
      end

      factory :unpublished_news_entry do
        publish false
      end
    end
  end
end
