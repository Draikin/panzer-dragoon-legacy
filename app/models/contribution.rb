class Contribution < ApplicationRecord
  belongs_to :contributor_profile
  belongs_to :contributable, polymorphic: true, optional: true
end
