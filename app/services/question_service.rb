class QuestionService
  def list_by_status_and_user status, user
    questions = Question.includes(:user, :question_alternatives, :question_revisions).order('updated_at DESC')
    questions = questions.where('status = ?', [status]) unless status == nil
    questions = questions.where('user_id = ?', [user.id]) unless user.is_admin
    questions
  end
  def show id, user
    question = Question.includes(:user, :question_alternatives, :question_revisions).find(id)
    raise ForbiddenException.new unless user.is_admin || question.user_id == user.id
    question
  end
  def create obj, user
    Question.transaction do
      question = Question.new
      self.save(question, obj, user)
      question
    end
  end
  def review obj, user
    raise ForbiddenException.new unless user.is_admin
    status = obj[:status]
    raise ValidationException.new({ :status => ["invalid status"] }) unless ['R', 'A'].include?(status)
    Question.transaction do
      question = self.show(obj[:question_id], user)
      raise ValidationException.new({ :status => ["invalid question status"] }) unless question.status == 'P'
      question.status = status
      question.save!

      comment = obj[:comment]
      if status === "A"
        comment = "Aprovada"
      end

      revision = QuestionRevision.new
      revision.user = user
      revision.comment = comment
      revision.question = question

      if !revision.save
        raise ValidationException.new(revision.errors)
      end
      question
    end
  end
  def update obj, user
    Question.transaction do
      question = self.show(obj[:id], user)
      raise ForbiddenException.new unless question.user_id == user.id
      raise ValidationException.new({ :status => ["invalid question status"] }) unless question.status == 'R'
      question.question_alternatives.destroy_all
      question.status = "P"
      self.save(question, obj, user)
      question
    end
  end

  def save question, obj, user
    raise ValidationException.new({ :alternatives => ["Invalid"] }) if obj[:alternatives] == nil || !obj[:alternatives].kind_of?(Array) || obj[:alternatives].length != 5
    question.content = obj[:content]
    question.source = obj[:source]
    question.year = obj[:year]
    question.user = user
    if !question.save
      raise ValidationException.new(question.errors)
    end

    question.question_alternatives.build
    obj[:alternatives].each do |alternative|
      alt = QuestionAlternative.new
      alt.content = alternative[:content]
      alt.is_correct = alternative[:is_correct]
      alt.question = question

      if !alt.save
        raise ValidationException.new(alt.errors)
      end
    end
  end
end