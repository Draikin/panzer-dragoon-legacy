require 'rails_helper'

describe PoemPolicy do
  subject { described_class.new(user, poem) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Poem.all).resolve
  end
  
  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new poem' do
      let(:poem) { Poem.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing a published poem' do
      let(:poem) { FactoryGirl.create(:published_poem) }

      it 'includes poem in resolved scope' do
        expect(resolved_scope).to include(poem)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished poem' do
      let(:poem) { FactoryGirl.create(:unpublished_poem) }

      it 'includes poem in resolved scope' do
        expect(resolved_scope).to include(poem)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
