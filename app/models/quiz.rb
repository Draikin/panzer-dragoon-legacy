class Quiz < ActiveRecord::Base
  include Sluggable
  
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations
  has_many :quiz_questions, :dependent => :destroy  
  accepts_nested_attributes_for :quiz_questions, 
    :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
end
