class NotFoundError < ApplicationError
  def self.with(klass, attribute, value)
    self.looked_for("#{klass.to_s.humanize} with #{attribute} #{value}")
  end

  def self.looked_for(thing)
    new("#{thing} not found")
  end
end
