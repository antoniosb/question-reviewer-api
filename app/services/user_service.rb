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
end