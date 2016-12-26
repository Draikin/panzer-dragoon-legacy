require 'rails_helper'

describe ContributorProfilePolicy do
  subject { described_class.new(user, contributor_profile) }

  let(:resolved_scope) do
    described_class::Scope.new(user, ContributorProfile.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new contributor profile' do
      let(:contributor_profile) { ContributorProfile.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.create(:published_contributor_profile)
      end

      it 'includes contributor profile in resolved scope' do
        expect(resolved_scope).to include(contributor_profile)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.create(:unpublished_contributor_profile)
      end

      it 'excludes contributor profile from resolved scope' do
        expect(resolved_scope).not_to include(contributor_profile)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
