class CreateQuestionAlternatives < ActiveRecord::Migration[5.2]
  def change
    create_table :question_alternatives do |t|
      t.string :content
      t.references :question, foreign_key: true
      t.boolean :is_correct

      t.timestamps
    end
  end
end
