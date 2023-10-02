require 'minitest/autorun'
require_relative '../../src/lib/report_generator'
require_relative '../../src/lib/game'
require_relative '../../src/lib/player_ranking_service'
require_relative '../../src/lib/death_causes_ranking_service'

class ReportGeneratorTest < Minitest::Test

  def setup
    @game = QuakeLog::Game.new
    @game.process_kill("player1", "player2", "MOD_SHOTGUN")
    @game.process_kill("<world>", "player2", "MOD_FALLING")

    @games = { "game-1" => @game }
    @report_generator = QuakeLog::ReportGenerator.new(@games)
  end

  def test_generate_with_valid_data
    report = @report_generator.generate

    assert report.is_a?(Array)
    assert_includes report, "game-1"
    assert_includes report, "Ranking:"
    assert_includes report, "1. player1 - 1 kills"
    assert_includes report, "2. player2 - -1 kills"
    assert_includes report, "Death Causes Ranking:"
    assert_includes report, "MOD_SHOTGUN: 1 times"
    assert_includes report, "MOD_FALLING: 1 times"
  end

  def test_generate_with_no_kills
    empty_game = QuakeLog::Game.new
    @games["game-2"] = empty_game
    report_generator = QuakeLog::ReportGenerator.new(@games)

    report = report_generator.generate

    assert_includes report, "game-2"
    assert_includes report, "No players found"
  end

  def test_generate_with_multiple_games
    another_game = QuakeLog::Game.new
    another_game.process_kill("player3", "player4", "MOD_GRENADE")
    @games["game-2"] = another_game
    report_generator = QuakeLog::ReportGenerator.new(@games)

    report = report_generator.generate

    assert_includes report, "game-2"
    assert_includes report, "1. player3 - 1 kills"
    assert_includes report, "2. player4 - 0 kills"
    assert_includes report, "MOD_GRENADE: 1 times"
  end
end
