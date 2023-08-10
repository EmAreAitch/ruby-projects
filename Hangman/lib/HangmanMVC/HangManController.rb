class HangManController
  attr_reader :model, :view

  def initialize
    @model = HangManModel.new
    @view = HangManView.new
    @cursor = TTY::Cursor
  end

  # Handles various screens of the game
  def start_game
    loop do
      main_menu_choice = main_menu()
      case main_menu_choice
      when "New Game"
        prepare_new_game
      when "Load Game"
        prepare_load_game
      when "Exit"
        exit_game()
      end
      main_game
    end
  end

  # Handless main menu interaction
  def main_menu
    menu = model.game_menu
    menu_screen = view.prepare_main_menu(menu)
    error = view.menu_error(menu)
    clear_screen()
    display(menu_screen)
    user_choice = take_valid_input(:validate_game_menu_input, error).to_i
    menu[user_choice - 1]
  end

  # Gets name and difficulty for new game
  def prepare_new_game
    name = ask_name()
    return false if name == "0"
    difficulty = ask_difficulty()
    return false if difficulty == "0"
    model.new_game(name, difficulty.to_i - 1)
    return true
  end

  # Handles saved data screen interaction and loads previously saved game
  def prepare_load_game
    clear_screen
    save_data = model.retrieve_saved_data
    unless save_data.size.zero?
      headers = model.save_file_info()[:headers]
      save_data_screen = view.prepare_saved_data(save_data, headers)
      display(save_data_screen)
      error = view.save_error(save_data)
      user_save = take_valid_input(:validate_save_input, error)
      model.load_game(user_save)
      return if user_save == "0"
      display "\nSave successfully loaded\n"
      display "\nPress any key to continue"
    else
      display(view.no_save_error)
    end
    pause_screen
  end

  # Exits game
  def exit_game
    display("\nThanks for playing")
    display("\n\nPress any key to exit")
    pause_screen
    exit
  end

  # Handles asking name and validating it with the help of model
  def ask_name
    naming_rules = model.naming_rules
    name_screen = view.prepare_name_input_screen(naming_rules)
    error = view.name_error
    clear_screen()
    display(name_screen)
    user_input = take_valid_input(:validate_name_input, error)
    user_input
  end

  # Handles asking difficulty and validating it with the help of model
  def ask_difficulty
    menu = model.difficulty_menu
    menu_screen = view.prepare_difficulty_input_screen(menu)
    error = view.menu_error(menu)
    clear_screen
    display(menu_screen)
    user_input = take_valid_input(:validate_difficulty_input, error)
    user_input
  end

  # Handles retreiving of secret word and beginning that word round
  def main_game
    round_start_msg = view.round_start_msg()
    while model.game_flag
      clear_screen()
      model.set_round
      display(round_start_msg)
      begin_round()
    end
  end

  # Handles each word round and takes guesses from the player
  def begin_round
    next_round_msg = view.next_round_msg
    while model.round_flag
      round_screen = view.prepare_round(model.round_data)
      display(round_screen)
      if model.round_won?
        model.next_round
        display(next_round_msg)
      elsif model.round_lost?
        model.restart_game
        round_lost_msg = view.round_lost_msg(model.secret_word)
        display(round_lost_msg)
      else
        on_going_round = view.on_going_round(model.guessed_letters)
        display(on_going_round)
        error = view.letter_error
        user_letter = take_valid_input(:validate_letter_input, error)
        result_msg = model.process_letter(user_letter)
        display(result_msg)
      end
      display("\nPress any key to continue")
      pause_screen()
      clear_screen()
    end
  end

  # Handles retreiving valid input based on pattern derived from model
  def take_valid_input(method, error_message = "")
    save_cursor_position()
    loop do
      value = take_input()
      return value if (model.send(method, value))
      msg = "\nInvalid Input: #{error_message}"
      display(msg)
      pause_screen()
      return_to_saved_cursor()
    end
  end

  def display(msg)
    print msg
  end

  def clear_screen
    STDOUT.clear_screen
  end

  def pause_screen
    STDIN.getch
  end

  def take_input
    gets.strip
  end

  # Saves cursor position for later retrieval for the sake of handling output screen dynamically
  def save_cursor_position
    print @cursor.save
  end

  # Return to previously saved cursor and clears screen content below 
  def return_to_saved_cursor
    print @cursor.restore
    print @cursor.clear_screen_down
  end
end
