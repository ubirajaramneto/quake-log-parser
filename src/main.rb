require 'json'
require_relative 'lib/log_parser'
require_relative 'lib/game_manager'
require_relative 'lib/player_ranking_service'
require_relative 'lib/death_causes_ranking_service'
require_relative 'lib/report_generator' # Add this line

game_manager = QuakeLog::GameManager.new
parser = QuakeLog::LogParser.new("./spec/fixtures/qgames.log", game_manager)
parser.parse

reporter = QuakeLog::ReportGenerator.new(game_manager.games)
report = reporter.generate

report.each { |line| puts line }
