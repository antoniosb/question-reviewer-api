class Question < ApplicationRecord
  validates :content, presence: true
  validates :source, presence: true
  validates :year, presence: true
  belongs_to :user
  has_many :question_alternatives
  has_many :question_revisions
end
