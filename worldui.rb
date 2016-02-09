require './person.rb'
require './politician.rb'
require './voter.rb'

# Voter Simulator.
class WorldUI
  # Start the person database.
  def initialize
    @directory = []
  end

  def main_menu
    puts "What would you like to do?"
    puts "(C)reate, (L)ist, (U)pdate, (D)elete or (Q)uit:"
    action = gets.chomp.capitalize
    case action
    when "C"
      get_type
    # Display directory of created characters.
    when "L"
      directory
    # Update user information.
    when "U"
      update
    # Delete a created user. Show directory.
    when "D"
      delete
    # Ends the simulator.
    when "Q"
      puts "Thank you for using this Voter Simulator. Have a great day!"
      puts "*" * 60
      puts ""
      exit
    else
      puts "Not a valid action. Try again."
    end
    main_menu
  end

  # Asks for the type of person.
  def get_type
    puts "What type of person would you like to create?"
    puts "(P)olitician or (V)oter"
    type = gets.chomp.capitalize
    case type
    when "P"
      name = get_name
      get_party(name)
    when "V"
      name = get_name
      get_view(name)
    else
      puts "Not a valid type of person. Try again."
      get_type
    end
  end

  # Asks for the name of the person.
  def get_name
    puts "Name?"
    name = gets.chomp.split.map(&:capitalize).join(' ')
  end

  # Asks for the political party of a policitian.
  def get_party(name)
    puts "Party?"
    politician_party = get_political_party(name)
    unless politician_party.eql? nil
      create_politician(name, politician_party)
    else
      puts "Not a valid political party. Try again."
      get_party(name)
    end
  end

  # Asks for the political view of the voter.
  def get_view(name)
    puts "Political View?"
    voter_view = get_political_view(name)
    unless voter_view.eql? nil
      create_voter(name, voter_view)
    else
      puts "Not a valid political View. Try again."
      get_view(name)
    end
  end

  # Asks for the political view of a voter.
  def get_political_view(name)
    puts "(L)iberal, (C)onservative, (T)ea Party, (S)ocial, or (N)eutral"
    view = gets.chomp.capitalize
    if view == "L" || view == "C" || view == "T" || view == "S" || view == "N"
      return view
    end
  end

  # Returns the political party of a politician.
  def get_political_party(name)
    puts "(D)emocrat or (R)epublican"
    party = gets.chomp.capitalize
    if party == "R" || party == "D"
      return party
    end
  end

  # Create a voter.
  def create_voter(name, view)
    voter = Voter.new(name: name, political_view: view)
    @directory.push(voter)
    puts "Added voter: #{name}, who is a #{voter.political_view}."
  end

  # Creates the politician.
  def create_politician(name, party)
    politician = Politician.new(name: name, political_party: party)
    @directory.push(politician)
    puts "Added politician: #{name} -> #{politician.political_party}."
  end

  # Prints the directory of current registered people.
  def directory
    puts ""
    if @directory.length != 0
      @directory.sort_by! { |person| person.name }
      if found_voter?
        puts "List of voters:"
        find_voters
      end
      if found_politician?
        puts "List of politicians:"
        find_politicians
      end
    else
      puts "Empty directory."
    end
    puts ""
  end

  # Returns the location of a person on the directory, if found.
  def find_person(name)
    index = 0
    @directory.each do |person|
      if person.name == name
        return index
      end
      index += 1
    end
    index = nil
  end

  # Update information from a person in the directory.
  def update
    if @directory.length != 0
      directory
      puts "Who would you like to update?"
      update_name = gets.chomp.split.map(&:capitalize).join(' ')
      # Verify is user exists.
      index = find_person(update_name)
      if index != nil
        puts "Change the name? (Y)es or (N)o:"
        verify = gets.chomp.capitalize
        if verify == "Y"
          puts "Enter new name:"
          new_name = gets.chomp.split.map(&:capitalize).join(' ')
          # Verify if person is a politician.
          if @directory[index].class == Politician
            update_party(update_name, new_name, index)
          else
            update_view(update_name, new_name, index)
          end
        elsif verify == "N"
          new_name = update_name
          # Verify if person is a politician.
          if @directory[index].class == Politician
            update_party(update_name, new_name, index)
          else
            update_view(update_name, new_name, index)
          end
        else
          puts "Not a valid entry. Try again."
          update
        end
      else
        puts "Not a registered person on the directory. Try again? (Y)es or (N)o:"
        try_again
      end
    else
      directory
    end
  end

  # Delete a person from the directory.
  def delete
    if @directory.length != 0
      directory
      puts "Who do you want to delete?"
      person_to_delete = gets.chomp.split.map(&:capitalize).join(' ')
      p person_to_delete
      index = find_person(person_to_delete)
      if index != nil
        puts "Are you sure? (Y)"
        confirm = gets.chomp.capitalize
        if confirm == "Y"
          @directory.delete_at(index)
          directory
        else
          puts "#{person_to_delete} was not deleted from directory."
        end
      else
        puts "Not a registered person on the directory."
      end
    else
      directory
    end
  end

  # Updates a person's political party affiliation.
  def update_party(update_name, new_name, index)
    puts "New Party?"
    new_party = get_political_party(update_name)
    unless new_party.eql? nil
      @directory[index].name = new_name
      @directory[index].set_political_party(new_party)
      puts "Updated politician information for #{@directory[index].name} -> #{@directory[index].political_party}."
    else
      puts "Not a valid political party. Try again."
      update_party(update_name, new_name, index)
    end
  end

  # Updates a person's political view.
  def update_view(update_name, new_name, index)
    puts "New Political View?"
    new_view = get_political_view(update_name)
    unless new_view.eql? nil
      @directory[index].name = new_name
      @directory[index].set_political_view(new_view)
      puts "Updated voter information for #{@directory[index].name} -> #{@directory[index].political_view}."
    else
      puts "Not a valid political view. Try again."
      update_view(update_name, new_name, index)
    end
  end

  # Asks the user input to try again an option for update.
  def try_again
    try_again = gets.chomp.split.map(&:capitalize).join(' ')
    if try_again == "Y"
      update
    elsif try_again == "N"
      main_menu
    else
      puts "Not a valid option. Skipping to main menu."
      main_menu
    end
  end

  # Determines if there is a politician in the directory.
  def found_politician?
    @directory.each do |person|
      if person.class == Politician
        return true
      end
    end
    return false
  end

  # Returns a new directory of the registered politicians.
  def find_politicians
    @directory.each do |person|
      if person.class == Politician
        puts "  #{person.name} -> #{person.political_party}."
      end
    end
  end

  # Determines if there is a voter in the directory.
  def found_voter?
    @directory.each do |person|
      if person.class == Voter
        return true
      end
    end
    return false
  end

  # Returns a new directory of the registered voters.
  def find_voters
    @directory.each do |person|
      if person.class == Voter
        puts "  #{person.name} -> #{person.political_view}."
      end
    end
  end
end

start = WorldUI.new
system "clear"
puts "VOTER SIMULATOR"
puts "*" * 15
start.main_menu
