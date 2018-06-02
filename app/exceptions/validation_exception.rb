class ValidationException < StandardError
  attr_accessor :errors
  def initialize data
    self.errors = data
  end
end