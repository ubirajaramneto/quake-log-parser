require_relative 'game'

module QuakeLog
  # Manages multiple game sessions, providing functionalities to start new games
  # and record kills within them.
  #
  # @author [Ubirajara Marsicano Neto]
  # @example Creating a game manager and starting a new game
  #   manager = GameManager.new
  #   game = manager.start_new_game
  class GameManager
    # @return [Hash<String, Game>] a dictionary of game sessions, indexed by their unique keys
    attr_reader :games

    # Initializes a new game manager with an empty set of games.
    def initialize
      @games = {}
    end

    # Starts a new game, assigns it a unique key, and adds it to the managed games.
    #
    # @return [Game] the newly started game instance
    # @example Starting a new game
    #   game = manager.start_new_game
    def start_new_game
      game_key = "game-#{@games.size + 1}"
      current_game = Game.new
      @games[game_key] = current_game
      current_game
    end

    # Records a kill in the specified game.
    #
    # @param game [Game] the game instance in which the kill took place
    # @param killer [String] the name of the player who made the kill
    # @param killed [String] the name of the player who got killed
    # @param means_of_death [String] the method or weapon used for the kill
    # @return [void]
    # @example Recording a kill in a game
    #   manager.record_kill(game, "Player1", "Player2", "MOD_SHOTGUN")
    def record_kill(game, killer, killed, means_of_death)
      game.process_kill(killer, killed, means_of_death)
    end
  end
end
