class HangManModel
  include GameSave
  attr_reader :game_flag, :game, :round_flag, :guessed_letters, :saved_data, :secret_word
  WORD_FILES = {
    easy: "words files/easywords.txt",
    medium: "words files/mediumwords.txt",
    hard: "words files/hardwords.txt",
  }

  def game_menu
    ["New Game", "Load Game", "Exit"]
  end

  def difficulty_menu
    [
      { name: "Easy", guesses: 15, multiplier: 1 },
      { name: "Medium", guesses: 10, multiplier: 2 },
      { name: "Hard", guesses: 5, multiplier: 3 },
    ]
  end

  def validate_difficulty_input(input)
    input.match?(/^[0-#{difficulty_menu.size}]$/)
  end

  def validate_letter_input(input)
    input.match?(/^[a-z0]$/i)
  end

  def validate_name_input(input)
    input.match?(/^(0|[a-z]\w{4,9})$/i)
  end

  def naming_rules
    ["Must start with a alphabet", "Minimum 5 and maximum 10 characters"]
  end

  def validate_game_menu_input(input)
    input.match?(/^[1-#{game_menu.size}]$/)
  end

  def validate_save_input(input)
    number_of_saves = @saved_data.size
    input.match?(/^[0-#{number_of_saves}]$/)
  end

  # Initalizes new game state with name and difficulty
  def new_game(name, difficulty)
    @game = HangManNewGame.new(name, difficulty_menu[difficulty])
    @game_flag = true
    @max_guesses = difficulty_menu[difficulty][:guesses]
    @multiplier = difficulty_menu[difficulty][:multiplier]
  end

  # Retreives stick figure body part presentation on the basis of ratio of incorrect guesses and max guesses
  def get_stick_figure
    stick_parts = [
      ["   ______", "  |      |", "  |", "  |", "  |", "__|__"],
      ["   ______", "  |      |", "  |", "  |", "  |     / \\", "__|__"],
      ["   ______", "  |      |", "  |", "  |      |", "  |     / \\", "__|__"],
      ["   ______", "  |      |", "  |", "  |     /|", "  |     / \\", "__|__"],
      ["   ______", "  |      |", "  |", "  |     /|\\", "  |     / \\", "__|__"],
      ["   ______", "  |      |", "  |      O", "  |     /|\\", "  |     / \\", "__|__"],
    ]
    part_to_draw = (@current_inc_guess / (@max_guesses / 5)).to_i
    stick_figure = stick_parts[part_to_draw].join("\n")
    stick_figure
  end

  # Retrieves random word on the basis of round  and set it as secret word
  def set_secret_word
    round = @game[:round]
    file = case round
      when 1..5
        WORD_FILES[:easy]
      when 6..15
        WORD_FILES[:medium]
      else
        WORD_FILES[:hard]
      end
    @secret_word = nil
    File.foreach(file).each_with_index { |value, index| @secret_word = value if rand(index + 1).zero? }
    @secret_word.strip!
    return nil
  end

  # Set state of round
  def set_round
    set_secret_word
    @word_pattern = ("_ " * @secret_word.length).strip
    @round_flag = true
    @letters_left_to_guess = @secret_word.length
    @current_inc_guess = 0
    @guessed_letters = []
  end

  # Return current round state
  def round_data
    {
      round: @game[:round], max_round: @game[:max_round],
      score: @game[:score], max_score: @game[:max_score],
      stick_figure: get_stick_figure(),
      current_inc_guess: @current_inc_guess, max_guesses: @max_guesses,
      word_pattern: @word_pattern,
    }
  end

  def round_won?
    @letters_left_to_guess.zero?
  end

  def next_round
    @game[:round] += 1
    @game[:max_round] = @game[:round] if (@game[:round] > @game[:max_round])
    @round_flag = false
  end

  def round_lost?
    @current_inc_guess == @max_guesses
  end

  def restart_game
    @game[:round] = 1
    @game[:score] = 0
    @round_flag = false
  end

  def retrieve_saved_data
    @saved_data = read_save_data
  end

  # Prcoesses user guess
  def process_letter(letter)
    letter.downcase!
    if letter == "0" # If user asked to save game
      @round_flag = false
      @game_flag = false
      ensure_save_file
      @game.save # Saves game state
      return "\nSave Successfull\n"
    elsif @guessed_letters.include?(letter) # If user guessed the same letter again
      return "\nOoops!! You have already guessed that before\n"
    else # Check whether guess is right or not
      @guessed_letters << letter
      correct_positions = find_correct_positions(letter)
      if (correct_positions.size.zero?) # Guess is wrong as the there no position for that guess
        incorrect_guess()
        return "\nOoppss!! That was incorrect\n"
      else # Guess is correct 
        correct_guess(correct_positions, letter)
        return "\nCorrect Guess!!!!\n"
      end
    end
  end

  # Find positions in the secret word where the user guessed letter exists
  def find_correct_positions(letter)
    correct_position = Array.new
    @secret_word.each_char.with_index do |k, i|
      if (k == letter)
        correct_position << i
      end
    end
    correct_position
  end

  # Updates round state after the guess is correct
  def correct_guess(correct_positions, letter)
    @game[:score] += 10 * @multiplier
    @game[:max_score] = @game[:score] if (@game[:score] > @game[:max_score])
    correct_positions.each { |k| @word_pattern[k * 2] = letter }
    @letters_left_to_guess -= correct_positions.size
  end

  # Updates round state after the guess is incorrect
  def incorrect_guess()
    @game[:score] -= 5 if @game[:score] > 0
    @current_inc_guess += 1
  end

  # Initializes load game state with user save choice
  def load_game(user_save_choice)
    user_save_choice = user_save_choice.to_i
    unless user_save_choice.zero?
      @game = HangManLoadGame.new(@saved_data, user_save_choice)
      difficulty = difficulty_menu.find { |hash| hash[:name] == @game[:difficulty] }
      @max_guesses = difficulty[:guesses]
      @multiplier = difficulty[:multiplier]
      @game_flag = true
      @saved_data = nil
    else
      @saved_data = nil
    end
  end
end
