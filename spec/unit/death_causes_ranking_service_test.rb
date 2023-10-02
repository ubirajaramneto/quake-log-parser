require 'minitest/autorun'
require_relative '../../src/lib/death_causes_ranking_service'
require_relative '../../src/lib/game'

class DeathCauseRankingServiceTest < Minitest::Test

  def setup
    @game = QuakeLog::Game.new
  end

  def test_rank_death_causes_with_no_deaths
    result = QuakeLog::DeathCauseRankingService.rank_death_causes(@game)
    assert_empty result
  end

  def test_rank_death_causes_with_single_death_cause
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    result = QuakeLog::DeathCauseRankingService.rank_death_causes(@game)

    assert_equal [["MOD_SHOTGUN", 1]], result
  end

  def test_rank_death_causes_with_multiple_death_causes
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    @game.process_kill("player2", "player1", "MOD_ROCKET")
    @game.process_kill("player3", "player4", "MOD_ROCKET")
    result = QuakeLog::DeathCauseRankingService.rank_death_causes(@game)

    assert_equal [["MOD_ROCKET", 2], ["MOD_SHOTGUN", 1]], result
  end

  def test_rank_death_causes_with_ties
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    @game.process_kill("player2", "player1", "MOD_ROCKET")
    @game.process_kill("player3", "player4", "MOD_PLASMA")
    result = QuakeLog::DeathCauseRankingService.rank_death_causes(@game)

    # Note: The order may depend on the insertion order if tied
    assert_equal [["MOD_PLASMA", 1], ["MOD_ROCKET", 1], ["MOD_SHOTGUN", 1]], result.sort
  end

end
