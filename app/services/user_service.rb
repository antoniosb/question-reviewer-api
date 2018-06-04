class UserService
  def create obj
    user = User.new
    user.login = obj[:login]
    user.password = obj[:password]
    user.is_admin = false
    if !user.save
      raise ValidationException.new(user.errors)
    end
    user
  end

  def show id
    User.find(id)
  end

  def login obj
    raise ValidationException.new({ :login => ["invalid"] }) unless obj[:login]
    raise ValidationException.new({ :password => ["invalid"] }) unless obj[:password]
    User.find_by(login: obj[:login]).try(:authenticate, obj[:password])
  end
end