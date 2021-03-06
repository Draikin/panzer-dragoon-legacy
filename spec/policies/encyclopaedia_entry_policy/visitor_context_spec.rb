require 'rails_helper'

describe EncyclopaediaEntryPolicy do
  subject { described_class.new(user, encyclopaedia_entry) }

  let(:resolved_scope) do
    described_class::Scope.new(user, EncyclopaediaEntry.all).resolve
  end

  let(:user) { nil }

  context 'visitor creating a new encyclopaedia entry' do
    let(:encyclopaedia_entry) { EncyclopaediaEntry.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'visitor accessing encyclopaedia entries in a published category' do
    context 'accessing a published encyclopaedia entry' do
      let(:encyclopaedia_entry) do
        FactoryGirl.create(
          :published_encyclopaedia_entry_in_published_category
        )
      end

      it 'includes encyclopaedia entry in resolved scope' do
        expect(resolved_scope).to include(encyclopaedia_entry)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished encyclopaedia entry' do
      let(:encyclopaedia_entry) do
        FactoryGirl.create(
          :unpublished_encyclopaedia_entry_in_published_category
        )
      end

      it 'excludes encyclopaedia entry from resolved scope' do
        expect(resolved_scope).not_to include(encyclopaedia_entry)
      end

      it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'visitor accessing encyclopaedia entries in an unpublished ' \
          'category' do
    context 'accessing a published encyclopaedia entry' do
      let(:encyclopaedia_entry) do
        FactoryGirl.create(
          :published_encyclopaedia_entry_in_unpublished_category
        )
      end

      it 'excludes encyclopaedia entry from resolved scope' do
        expect(resolved_scope).not_to include(encyclopaedia_entry)
      end

      it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished encyclopaedia entry' do
      let(:encyclopaedia_entry) do
        FactoryGirl.create(
          :unpublished_encyclopaedia_entry_in_unpublished_category
        )
      end

      it 'excludes encyclopaedia entry from resolved scope' do
        expect(resolved_scope).not_to include(encyclopaedia_entry)
      end

      it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
