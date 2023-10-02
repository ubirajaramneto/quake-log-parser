module QuakeLog
  # The ReportGenerator class generates a report for QuakeLog games,
  # displaying a ranking of players based on kills, and a summary of death causes.
  #
  # @author [Ubirajara Marsicano Neto]
  class ReportGenerator
    # Initializes a new ReportGenerator instance.
    #
    # @param games [Hash] a collection of games with game_keys as keys and Game objects as values
    def initialize(games)
      @games = games
    end

    # Generates a detailed report of games, including players' rankings and death causes statistics.
    #
    # @return [Array<String>] an array containing the report lines
    # @example Generating a report from a collection of games
    #   games = {
    #     "game-1" => game_obj_1,
    #     "game-2" => game_obj_2
    #   }
    #   report_generator = ReportGenerator.new(games)
    #   report = report_generator.generate
    #   # => ["game-1", "---------------------------------", "Ranking:", ...]
    def generate
      report = []

      @games.each do |game_key, game_obj|
        report << game_key
        report << "---------------------------------"

        unless game_obj.kills.any?
          report << "No players found"
          report << "================================="
          next
        end

        report << "Ranking:"
        ranked_players = PlayerRankingService.rank_players(game_obj)
        ranked_players.each_with_index do |player, index|
          report << "#{index + 1}. #{player} - #{game_obj.kills[player]} kills"
        end
        report << "---------------------------------"
        report << "Death Causes Ranking:"
        death_causes_ranking = DeathCauseRankingService.rank_death_causes(game_obj)
        death_causes_ranking.each do |cause, count|
          report << "#{cause}: #{count} times"
        end
        report << "================================="
      end

      report
    end
  end
end
