module QuakeLog
  # A service module responsible for ranking the causes of death in the game based on frequency.
  #
  # @author [Ubirajara Marsicano Neto]
  module DeathCauseRankingService
    # Ranks the causes of death in a given game by their frequency.
    #
    # The causes are sorted in descending order, so the most frequent cause of death will be the first in the list.
    #
    # @param game [Game] an instance of the Game class that contains death data
    # @return [Array<Array<String, Integer>>] an array of pairs, where each pair consists of a death cause and its frequency
    # @example Rank the death causes in a game
    #   game = Game.new
    #   # ... [populate game with some data]
    #   DeathCauseRankingService.rank_death_causes(game)
    #   # => [["MOD_SHOTGUN", 5], ["MOD_ROCKET", 3], ...]
    def self.rank_death_causes(game)
      game.deaths_by_means.sort_by { |_, count| -count }
    end
  end
end
