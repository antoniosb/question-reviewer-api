class QuestionRevision < ApplicationRecord
  validates :comment, presence: true
  belongs_to :user
  belongs_to :question
end
