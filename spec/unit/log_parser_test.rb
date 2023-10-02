# test/log_parser_test.rb

require 'minitest/autorun'
require_relative '../../src/lib/log_parser'
require_relative '../../src/lib/game_manager'

class LogParserTest < Minitest::Test
  def setup
    @game_manager = QuakeLog::GameManager.new
    @logfile_path = 'spec/fixtures/qgames.log'
    @log_parser = QuakeLog::LogParser.new(@logfile_path, @game_manager)
  end

  def test_initialize
    assert_equal @logfile_path, @log_parser.instance_variable_get(:@logfile_path)
    assert_equal @game_manager, @log_parser.instance_variable_get(:@game_manager)
  end

  def test_parse_valid_log
    @log_parser.parse

    games = @game_manager.games
    assert_equal 21, games.length # Assumes one game in the sample log
    game = games.fetch('game-2')
    assert_equal 11, game.total_kills
    assert_equal ["Isgalamido", "Mocinha"], game.players
    assert_equal({"Isgalamido"=>-9, "Mocinha"=>0}, game.kills)
    assert_equal({
                  "MOD_TRIGGER_HURT"=>7,
                  "MOD_ROCKET_SPLASH"=>3,
                  "MOD_FALLING"=>1
                 }, game.deaths_by_means)
  end

  def test_extract_players_from_kill_line_valid_line
    line = "20:34 Kill: 1022 2 22: <world> killed Isgalamido by MOD_ROCKET"
    killer, killed, mod = @log_parser.send(:extract_players_from_kill_line, line)

    assert_equal "<world>", killer
    assert_equal "Isgalamido", killed
    assert_equal "MOD_ROCKET", mod
  end

  def test_extract_players_from_kill_line_invalid_line
    line = "Invalid Kill Line"
    killer, killed, mod = @log_parser.send(:extract_players_from_kill_line, line)

    assert_nil killer
    assert_nil killed
    assert_nil mod
  end
end
