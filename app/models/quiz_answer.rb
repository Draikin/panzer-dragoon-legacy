class QuizAnswer < ApplicationRecord
  belongs_to :quiz_question, optional: true
end
