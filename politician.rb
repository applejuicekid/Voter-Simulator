# Represents a valid politician.
class Politician < Person
  attr_accessor :political_party
  @@political_party = {"D" => "Democrat", "R" => "Republican"}
  def initialize(args)
    super(args)
    @political_party = @@political_party[args.fetch(:political_party)]
  end
  def set_political_party(a_political_party)
    @political_party = @@political_party[a_political_party]
  end
end
