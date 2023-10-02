require_relative 'death_causes'

module QuakeLog
  # Represents a single game session in QuakeLog, keeping track of kills, players, and
  # the methods of death.
  #
  # @author [Ubirajara Marsicano Neto]
  # @example Create a new game instance and process a kill
  #   game = Game.new
  #   game.process_kill("Player1", "Player2", "MOD_SHOTGUN")
  class Game
    include DeathCauses

    # @return [Integer] the total number of kills in the game
    attr_accessor :total_kills

    # @return [Array<String>] list of player names in the game
    attr_accessor :players

    # @return [Hash<String, Integer>] kill count for each player
    attr_accessor :kills

    # @return [Hash<String, Integer>] count of deaths by each means or method
    attr_accessor :deaths_by_means

    # Initializes a new game with zero kills, empty player list, and empty kill counts.
    def initialize
      @total_kills = 0
      @players = []
      @kills = {}
      @deaths_by_means = Hash.new(0) # default value is 0 for any key
    end

    # Processes a kill in the game, updating the relevant counters and lists.
    #
    # @param killer [String] the name of the player who made the kill
    # @param killed [String] the name of the player who got killed
    # @param means_of_death [String] the method or weapon used for the kill
    # @note This method handles special cases like world kills and suicides.
    def process_kill(killer, killed, means_of_death)
      @total_kills += 1

      if valid_death_cause?(means_of_death)
        @deaths_by_means[means_of_death] += 1
      else
        # We could throw an exception, but for now we will only log
        puts "Invalid death cause: #{means_of_death}"
      end

      # If the killer is the world, deduct a point from the killed player.
      if killer == "<world>"
        @kills[killed] = @kills.fetch(killed, 0) - 1
        # Add the 'killed' player to the list of players
        @players << killed unless @players.include?(killed)
        return
      end

      # Register the players
      [killer, killed].each do |player|
        # Ensure that each player shows up in the `kills` hash
        @kills[player] ||= 0
        @players << player unless @players.include?(player)
      end

      # If a player kills themselves, deduct a point (instead of making it neutral).
      # According to Quake 3 Arena wiki, a suicide by damage inflicted to self deduces a point from the player.
      # https://www.giantbomb.com/quake-iii-arena/3030-3874/
      if killer == killed
        @kills[killer] -= 1
        return
      end

      # Award a point to the killer.
      @kills[killer] += 1
    end

    # Converts the game data to a hash representation.
    #
    # @return [Hash<String, Object>] a hash representation of the game data
    # @example Get a hash representation of the game data
    #   game = Game.new
    #   hash = game.to_hash
    def to_hash
      {
        'total_kills' => @total_kills,
        'players' => @players,
        'kills' => @kills,
        'kills_by_means' => @deaths_by_means
      }
    end
  end

end