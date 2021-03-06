require 'rails_helper'

describe LinkPolicy do
  subject { described_class.new(user, link) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Link.all).resolve
  end

  let(:contributor_profile) { FactoryGirl.create(:valid_contributor_profile) }
  let(:user) do
    FactoryGirl.create(
      :contributor,
      contributor_profile: contributor_profile
    )
  end

  context 'contributor accessing links in a published category' do
    context 'accessing links that the user does not contribute to' do
      let(:link) { FactoryGirl.create(:link_in_published_category) }

      it 'includes link in resolved scope' do
        expect(resolved_scope).to include(link)
      end

      it { is_expected.to permit_action(:show) }
      it do
        is_expected.to forbid_actions(
          [:new, :create, :edit, :update, :destroy]
        )
      end
    end

    context 'accessing links the user contributes to' do
      let(:link) do
        FactoryGirl.create(
          :link_in_published_category,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes link in resolved scope' do
        expect(resolved_scope).to include(link)
      end

      it { is_expected.to permit_action(:show) }
      it do
        is_expected.to forbid_actions(
          [:new, :create, :edit, :update, :destroy]
        )
      end
    end
  end

  context 'contributor accessing links in an unpublished category' do
    context 'accessing links that the user does not contribute to' do
      let(:link) { FactoryGirl.create(:link_in_unpublished_category) }

      it 'excludes link in resolved scope' do
        expect(resolved_scope).not_to include(link)
      end

      it do
        is_expected.to forbid_actions(
          [:show, :new, :create, :edit, :update, :destroy]
        )
      end
    end

    context 'accessing links that the user contributes to' do
      let(:link) do
        FactoryGirl.create(
          :link_in_unpublished_category,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'excludes link in resolved scope' do
        expect(resolved_scope).not_to include(link)
      end

      it do
        is_expected.to forbid_actions(
          [:show, :new, :create, :edit, :update, :destroy]
        )
      end
    end
  end
end
