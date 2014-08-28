require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe "fields" do
    it { should respond_to(:chapter_type) }
    it { should respond_to(:number) }
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:content) }
    it { should respond_to(:publish) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  pending describe "validations" do
    it { should validate_presence_of(:number) }
    it { should validate_numericality_of(:number) }
    it { should validate_presence_of(:content) }
  end

  describe "associations" do
    it { should belong_to(:story) }
    it { should have_many(:illustrations).dependent(:destroy) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:illustrations).allow_destroy(true) }
  end

  pending describe "methods" do
    describe "#story_chapter_name" do

    end
  end
end
