# QuakeLog Parser

QuakeLog Parser is a Ruby-based tool designed to parse and analyze Quake 3 Arena game logs. The project provides functionalities to parse the log files, rank players based on their kills, and generate detailed reports.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Documentation](#documentation)

## Features

- Parse Quake 3 Arena game logs.
- Rank players based on the number of kills.
- Generate game summaries, including player rankings and death causes statistics.

## Installation

Clone the repository:

```sh
git clone https://github.com/ubirajaramneto/quake_log_parser.git
```

## Running the project

From the root project folder, run the `main.rb` ruby file.

```sh
ruby src/main.rb 
```

## Usage
Below is the source code from main.rb which is the main reference on how to use this library. 

```ruby
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
```

## Testing
Tests are written using the minitest framework. To run the tests, from the project root, simply execute:

```ruby
ruby test_runner.rb
```

## Edge cases for player suicide

For example:

22:18 Kill: 2 2 7: Isgalamido killed Isgalamido by MOD_ROCKET_SPLASH

Isgalamido killed himself due to MOD_ROCKET_SPLASH, since there were no specific instructions for handling this case,
I decided to deduct a point from the player.


## Documentation

This project is documented using YARD. To see the docs, make sure you have `yard` installed.

You can install it with:

```shell
gem install yard
```

Or you can run `bundle install` as the yard dependency is added to the project Gemfile.

After that, from the project root, run `yard doc src/`, and then `yard server`.

This way you can navigate the generated documentation for this project.

## Technical considerations

This project was developed using Windows 11 with WSL, using RubyMine.

The ruby version for this project was ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) x86_64-linux-gnu

