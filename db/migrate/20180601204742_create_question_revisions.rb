class CreateQuestionRevisions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_revisions do |t|
      t.text :comment
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
