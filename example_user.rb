class User
  attr_accessor :name, :email
  
  def initialize (attributes = {})
    @name,@email = attributes[:name],attributes[:email]
  end
  
  def formatted_email
    "#{@name}<#{@email}>"
  end
  
end