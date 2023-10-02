# test/game_test.rb

require 'minitest/autorun'
require_relative '../../src/lib/game'

class GameTest < Minitest::Test
  def setup
    @game = QuakeLog::Game.new
  end

  def test_initial_state
    assert_equal 0, @game.total_kills
    assert_empty @game.players
    assert_empty @game.kills
    assert_empty @game.deaths_by_means
  end

  def test_process_kill
    @game.process_kill('John', 'Doe', 'MOD_ROCKET')

    assert_equal 1, @game.total_kills
    assert_equal ['John', 'Doe'], @game.players
    assert_equal({ 'John' => 1, 'Doe' => 0 }, @game.kills)
    assert_equal({ 'MOD_ROCKET' => 1 }, @game.deaths_by_means)
  end

  def test_suicide_process
    @game.process_kill('Doe', 'Doe', 'MOD_FALLING')

    assert_equal 1, @game.total_kills
    assert_equal ['Doe'], @game.players
    assert_equal({ 'Doe' => -1 }, @game.kills)
    assert_equal({ 'MOD_FALLING' => 1 }, @game.deaths_by_means)
  end

  def test_world_kills_player
    @game.process_kill('<world>', 'Doe', 'MOD_UNKNOWN')

    assert_equal 1, @game.total_kills
    assert_equal ['Doe'], @game.players
    assert_equal({ 'Doe' => -1 }, @game.kills)
    assert_equal({ 'MOD_UNKNOWN' => 1 }, @game.deaths_by_means)
  end

  def test_invalid_death_cause
    # We would use a capture to test the log, but to keep it simple, we're testing the behavior only
    @game.process_kill('John', 'Doe', 'INVALID_CAUSE')

    assert_equal 1, @game.total_kills
    assert_equal ['John', 'Doe'], @game.players
    assert_equal({ 'John' => 1, 'Doe' => 0 }, @game.kills)
    assert_empty @game.deaths_by_means
  end

  def test_to_hash
    @game.process_kill('John', 'Doe', 'MOD_ROCKET')
    hash = @game.to_hash

    expected_hash = {
      'total_kills' => 1,
      'players' => ['John', 'Doe'],
      'kills' => { 'John' => 1, 'Doe' => 0 },
      'kills_by_means' => { 'MOD_ROCKET' => 1 }
    }

    assert_equal expected_hash, hash
  end
end
