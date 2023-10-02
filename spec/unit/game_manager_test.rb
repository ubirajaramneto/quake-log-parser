require 'minitest/autorun'
require_relative '../../src/lib/game_manager'

class GameManagerTest < Minitest::Test
  def setup
    @game_manager = QuakeLog::GameManager.new
  end

  def test_initialize
    # On initialization, the games hash should be empty
    assert_empty @game_manager.games
  end

  def test_start_new_game
    # When starting a new game, it should create a game instance and store it with a unique key
    initial_games_count = @game_manager.games.size
    new_game = @game_manager.start_new_game

    assert_instance_of QuakeLog::Game, new_game
    assert_equal initial_games_count + 1, @game_manager.games.size
  end

  def test_record_kill
    # Create a game and then record a kill
    game = @game_manager.start_new_game
    initial_kills_count = game.total_kills
    killer = "Player1"
    killed = "Player2"
    means_of_death = "MOD_ROCKET"

    @game_manager.record_kill(game, killer, killed, means_of_death)

    # The game's total kills should increase by 1
    assert_equal initial_kills_count + 1, game.total_kills

    # The kills hash for the game should correctly reflect the kill
    assert_equal 1, game.kills[killer]
    assert_equal 0, game.kills[killed]
  end

  def test_record_world_kill
    # Test the scenario where the killer is "<world>"
    game = @game_manager.start_new_game
    killer = "<world>"
    killed = "Player3"
    means_of_death = "MOD_FALLING"

    @game_manager.record_kill(game, killer, killed, means_of_death)

    # The game's total kills should increase by 1
    assert_equal 1, game.total_kills

    # The killed player should lose a point, but the killer (world) shouldn't gain any points
    assert_nil game.kills[killer] # The "<world>" should not exist in the kills hash
    assert_equal -1, game.kills[killed]
  end

  def test_record_suicide
    # Test the scenario where a player kills themselves
    game = @game_manager.start_new_game
    killer = "Player4"
    killed = "Player4"
    means_of_death = "MOD_SELFKILL"

    @game_manager.record_kill(game, killer, killed, means_of_death)

    # The game's total kills should increase by 1
    assert_equal 1, game.total_kills

    # The player should lose a point due to the suicide
    assert_equal -1, game.kills[killer]
  end
end
