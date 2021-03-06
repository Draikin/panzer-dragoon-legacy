FactoryGirl.define do
  factory :poem do
    factory :valid_poem do
      sequence(:name) { |n| "Poem #{n}" }
      description 'Test Description'
      content 'Test Content'

      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_poem do
        publish true
      end

      factory :unpublished_poem do
        publish false
      end
    end
  end
end
