# Create a valid person with a name.
class Person
  attr_accessor :name
  def initialize(args)
    @name = args.fetch(:name)
  end
end
