# Represents a valid voter.
class Voter < Person
  attr_accessor :political_view
  @@political_views = {"L" => "Liberal", "C" => "Conservative", "T" => "Tea Party", "S" => "Socialist", "N" => "Neutral"}
  def initialize(args)
    super(args)
    @political_view = @@political_views[args.fetch(:political_view)]
  end
  def set_political_view(political_view)
    @political_view = @@political_views[political_view]
  end
end
