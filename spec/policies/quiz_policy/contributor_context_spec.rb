require 'rails_helper'

describe QuizPolicy do
  subject { described_class.new(user, quiz) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Quiz.all).resolve
  end

  let(:contributor_profile) do
    FactoryGirl.create(:valid_contributor_profile)
  end
  let(:user) do
    FactoryGirl.create(
      :contributor,
      contributor_profile: contributor_profile
    )
  end

  context 'contributor accessing quizzes that the user does not contribute ' \
          'to' do
    context 'accessing a published quiz' do
      let(:quiz) { FactoryGirl.create(:published_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished quiz' do
      let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

      it 'excludes quiz from resolved scope' do
        expect(resolved_scope).not_to include(quiz)
      end

      it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'contributor accessing quizzes the user contributes to' do
    context 'accessing a published quiz' do
      let(:quiz) do
        FactoryGirl.create(
          :published_quiz,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished quiz' do
      let(:quiz) do
        FactoryGirl.create(
          :unpublished_quiz,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
