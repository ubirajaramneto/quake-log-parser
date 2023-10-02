require 'minitest/autorun'
require_relative '../../src/lib/player_ranking_service'
require_relative '../../src/lib/game'

class PlayerRankingServiceTest < Minitest::Test

  def setup
    @game = QuakeLog::Game.new
  end

  def test_rank_players_with_no_kills
    result = QuakeLog::PlayerRankingService.rank_players(@game)
    assert_empty result
  end

  def test_rank_players_with_single_player
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    result = QuakeLog::PlayerRankingService.rank_players(@game)

    assert_equal ["player1", "player2"], result
  end

  def test_rank_players_with_multiple_players
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    @game.process_kill("player2", "player1", "MOD_SHOTGUN")
    @game.process_kill("player2", "player1", "MOD_SHOTGUN")
    result = QuakeLog::PlayerRankingService.rank_players(@game)

    assert_equal ["player2", "player1"], result
  end

  def test_rank_players_with_ties
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    @game.process_kill("player2", "player1", "MOD_SHOTGUN")
    @game.process_kill("player3", "player4", "MOD_SHOTGUN")
    result = QuakeLog::PlayerRankingService.rank_players(@game)

    assert_equal ["player1", "player2", "player3", "player4"], result
  end

  def test_rank_players_with_negative_scores
    @game.process_kill("<world>", "player1", "MOD_FALLING")
    @game.process_kill("player2", "player1", "MOD_SHOTGUN")
    result = QuakeLog::PlayerRankingService.rank_players(@game)

    assert_equal ["player2", "player1"], result
  end
end
