module QuakeLog
  # A service module to rank players based on their kill count in a given game.
  #
  # @author [Ubirajara Marsicano Neto]
  module PlayerRankingService
    # Ranks players by their kill count in descending order.
    #
    # @param game [Game] an instance of the Game class containing player kills data
    # @return [Array<String>] a list of player names sorted by their kill count in descending order
    # @example Ranking players by their kills with ties
    #   game = Game.new
    #   game.process_kill("player1", "player2", "MOD_SHOTGUN")
    #   game.process_kill("player2", "player1", "MOD_SHOTGUN")
    #   game.process_kill("player3", "player4", "MOD_SHOTGUN")
    #   PlayerRankingService.rank_players(game)
    #   # => ["player1", "player2", "player3", "player4"]
    def self.rank_players(game)
      game.kills.sort_by { |_, kill_count| -kill_count }.map(&:first)
    end
  end
end
