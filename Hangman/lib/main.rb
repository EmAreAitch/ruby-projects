require_relative "HangmanMVC/GameState"
require_relative "HangmanMVC/HangManModel"
require_relative "HangmanMVC/HangManView"
require_relative "HangmanMVC/HangManController"
require "bundler/setup"
require "io/console"
require "tty-cursor"
require "tty-table"
require "time"
require "csv"

# Initialize the controller
controller = HangManController.new

# Start the game loop
controller.start_game