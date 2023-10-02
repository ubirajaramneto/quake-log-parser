module QuakeLog
  # A class responsible for parsing Quake 3 Arena log files and recording the
  # relevant game data through the provided game manager.
  #
  # @author [Ubirajara Marsicano Neto]
  class LogParser
    # Initializes a new instance of the LogParser class.
    #
    # @param logfile_path [String] the path to the Quake 3 Arena log file
    # @param game_manager [GameManager] an instance of the GameManager class to manage game data
    def initialize(logfile_path, game_manager)
      @logfile_path = logfile_path
      @game_manager = game_manager
    end

    # Parses the log file and records the relevant game data.
    #
    # Iterates through each line in the log file. For game initialization lines,
    # it starts a new game through the game manager. For kill lines, it extracts
    # the relevant kill data and records it through the game manager.
    def parse
      current_game = nil

      File.foreach(@logfile_path) do |line|
        if line.include?("InitGame")
          current_game = @game_manager.start_new_game
          next
        end

        if line.include?("Kill:")
          killer, killed, means_of_death = extract_players_from_kill_line(line)
          next unless killer && killed

          @game_manager.record_kill(current_game, killer, killed, means_of_death)
        end
      end
    end

    private

    # Extracts player names and the cause of death from a kill line in the log.
    #
    # @param line [String] the kill line from the log
    # @return [Array<String, String, String>] an array containing the killer's name, the killed player's name, and the means of death
    # @example Extracting data from a kill line
    #   extract_players_from_kill_line("20:34 Kill: 1022 2 22: <world> killed Isgalamido by MOD_ROCKET")
    #   # => ["<world>", "Isgalamido", "MOD_ROCKET"]
    def extract_players_from_kill_line(line)
      pattern = /Kill:.*?:\s(.*?) killed (.*?) by (\w+)/
      matches = line.match(pattern)

      if matches
        [matches[1].strip, matches[2].strip, matches[3]]
      else
        [nil, nil, nil]
      end
    end
  end
end
