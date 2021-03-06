require 'rails_helper'

describe StoryPolicy do
  subject { described_class.new(user, story) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Story.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'administrator creating a new story' do
    let(:story) { Story.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing stories in a published category' do
    context 'accessing a published story' do
      let(:story) do
        FactoryGirl.create(:published_story_in_published_category)
      end

      it 'includes story in resolved scope' do
        expect(resolved_scope).to include(story)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished story' do
      let(:story) do
        FactoryGirl.create(:unpublished_story_in_published_category)
      end

      it 'includes story in resolved scope' do
        expect(resolved_scope).to include(story)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing stories in an unpublished category' do
    context 'accessing a published story' do
      let(:story) do
        FactoryGirl.create(:published_story_in_unpublished_category)
      end

      it 'includes story in resolved scope' do
        expect(resolved_scope).to include(story)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished story' do
      let(:story) do
        FactoryGirl.create(:unpublished_story_in_unpublished_category)
      end

      it 'includes story in resolved scope' do
        expect(resolved_scope).to include(story)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
