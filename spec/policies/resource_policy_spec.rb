require 'rails_helper'

describe ResourcePolicy do
  subject { ResourcePolicy.new(user, resource) }

  let(:resolved_scope) {
    ResourcePolicy::Scope.new(user, Resource.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing resources in a published category" do
      context "accessing a published resource" do
        let(:resource) {
          FactoryGirl.create(:published_resource_in_published_category)
        }

        it "includes resource in resolved scope" do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished resource" do
        let(:resource) {
          FactoryGirl.create(:unpublished_resource_in_published_category)
        }

        it "excludes resource from resolved scope" do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
    
    context "accessing resources in an unpublished category" do
      context "accessing a published resource" do
        let(:resource) {
          FactoryGirl.create(:published_resource_in_unpublished_category)
        }

        it "excludes resource from resolved scope" do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished resource" do
        let(:resource) {
          FactoryGirl.create(:unpublished_resource_in_unpublished_category)
        }

        it "excludes resource from resolved scope" do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing resources in a published category" do
      context "accessing a published resource" do
        let(:resource) {
          FactoryGirl.create(:published_resource_in_published_category)
        }

        it "includes resource in resolved scope" do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished resource" do
        let(:resource) {
          FactoryGirl.create(:unpublished_resource_in_published_category)
        }

        it "excludes resource from resolved scope" do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing resources in an unpublished category" do
      context "accessing a published resource" do
        let(:resource) {
          FactoryGirl.create(:published_resource_in_unpublished_category)
        }

        it "excludes resource from resolved scope" do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished resource" do
        let(:resource) {
          FactoryGirl.create(:unpublished_resource_in_unpublished_category)
        }

        it "excludes resource from resolved scope" do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end

  context "being a contributor" do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor, 
        contributor_profile: contributor_profile
      )
    }

    context "accessing resources in a published category" do
      context "accessing resources that the user does not contribute to" do
        context "accessing a published resource" do
          let(:resource) {
            FactoryGirl.create(:published_resource_in_published_category)
          }

          it "includes resource in resolved scope" do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished resource" do
          let(:resource) {
            FactoryGirl.create(:unpublished_resource_in_published_category)
          }

          it "excludes resource from resolved scope" do
            expect(resolved_scope).not_to include(resource)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing resources the user contributes to" do
        context "accessing a published resource" do
          let(:resource) {
            FactoryGirl.create(
              :published_resource_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes resource in resolved scope" do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished resource" do
          let(:resource) {
            FactoryGirl.create(
              :unpublished_resource_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes resource in resolved scope" do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end

    context "accessing resources in an unpublished category" do
      context "accessing resources that the user does not contribute to" do
        context "accessing a published resource" do
          let(:resource) {
            FactoryGirl.create(:published_resource_in_published_category)
          }

          it "includes resource in resolved scope" do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished resource" do
          let(:resource) {
            FactoryGirl.create(:unpublished_resource_in_published_category) 
          }

          it "excludes resource from resolved scope" do
            expect(resolved_scope).not_to include(resource)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing resources that the user contributes to" do
        context "accessing a published resource" do
          let(:resource) {
            FactoryGirl.create(
              :published_resource_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes resource in resolved scope" do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished resource" do
          let(:resource) {
            FactoryGirl.create(
              :unpublished_resource_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes resource in resolved scope" do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing resources in a published category" do
      context "accessing a published resource" do
        let(:resource) {
          FactoryGirl.create(:published_resource_in_published_category)
        }

        it "includes resource in resolved scope" do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished resource" do
        let(:resource) {
          FactoryGirl.create(:unpublished_resource_in_published_category)
        }

        it "includes resource in resolved scope" do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end

    context "accessing resources in an unpublished category" do
      context "accessing a published resource" do
        let(:resource) {
          FactoryGirl.create(:published_resource_in_unpublished_category)
        }

        it "includes resource in resolved scope" do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished resource" do
        let(:resource) {
          FactoryGirl.create(:unpublished_resource_in_unpublished_category)
        }

        it "includes resource in resolved scope" do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end
  end
end
