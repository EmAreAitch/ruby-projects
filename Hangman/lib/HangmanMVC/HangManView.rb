class HangManView
  def round_start_msg
    "Random word generated!!!! Start making guesses\n"
  end

  def next_round_msg
    "\nLETS GOOO!! You guessed it right, now moving on to next word\n"
  end

  def round_lost_msg(word)
    "\nGAME OVER!! Thanks for Playing\n" \
    "\nThe word was: #{word}\n"
  end

  def take_input
    gets.strip
  end

  def no_save_error
    "Well.. Looks like there are no save files here"
  end

  def save_error(saves)
    number_of_saves = saves.size
    "Please enter value between 1 and #{number_of_saves} only"
  end

  def menu_error(menu)
    "Please enter between the range of 1 - #{menu.size}"
  end

  def name_error
    "Name does not follows naming rules"
  end

  def game_objective
    "Objective: The objective of Hangman is to guess a secret word letter by letter, without exceeding number of guesses else you'll be hanged"
  end

  def prepare_difficulty_input_screen(menu)
    menu = menu.map { |item| "#{item[:name]} (#{item[:guesses]} guesses)" }
    str = game_objective + "\n\n"
    str << "Choose difficulty - \n\n"
    str << ordered_menu(menu)
    str << "\nEnter choice or 0 to go back: "
    str
  end

  def save_cursor_position
    print cursor.save
  end

  def return_to_saved_cursor
    print cursor.restore
    print cursor.clear_screen_down
  end

  def prepare_name_input_screen(menu)
    str = game_objective + "\n\n"
    str << "Player name rules :-\n"
    str << ordered_menu(menu)
    str << "\nPlease enter your name or 0 to go back: "
    str
  end

  def prepare_round(data)
    "\nRound: #{data[:round]} | MAX: #{data[:max_round]}\n\n" \
    "\nOur HangMan\n\n" \
    "#{data[:stick_figure]}\n\n" \
    "\nScore: #{data[:score]} | MAX: #{data[:max_score]}\n" \
    "\nIncorrect guesses: #{data[:current_inc_guess]}/#{data[:max_guesses]}\n" \
    "\nCurrent Word\n\n\n" \
    "#{data[:word_pattern]}\n"
  end

  def letter_error()
    "Please enter only letters from a to z"
  end

  def on_going_round(guessed_letters)
    "\nEntered letters: #{guessed_letters.join(",")}\n" \
    "\nGuess any letter of the word or enter 0 to save and go back: "
  end

  def ordered_menu(menu)
    str = ""
    menu.each_with_index do |value, index|
      str << "#{index + 1}. #{value}\n"
    end
    str
  end

  def prepare_main_menu(menu)
    str = " O                    O \n" \
          "/|\\ THE HANGMAN GAME /|\\ \n" \
          "/ \\                  / \\  \n\n\n"
    str << ordered_menu(menu)
    str << "\nEnter Choice: "
    str
  end

  # Converts time object to relative time
  def relative_time(time)
    time_difference = Time.now - time
    if time_difference < 60
      formatted_time = time_difference.to_i
      str = "second"
    elsif time_difference < 3600
      formatted_time = (time_difference / 60).to_i
      str = "minute"
    elsif time_difference < 86400
      formatted_time = (time_difference / 3600).to_i
      str = "hour"
    else
      formatted_time = (time_difference / 86400).to_i
      str = "day"
    end
    return "#{formatted_time} " + str + (formatted_time != 1 ? "s" : "") + " ago"
  end

  # Set relative time on the retrieved save data
  def set_relative_time(data, column)
    data.map { |h| h[:last_played] = relative_time(Time.parse(h[:last_played])) }
    data
  end

  # Converts data to an elegant table
  def convert_hash_to_table(data, headers)
    data = data.map(&:values)
    table = TTY::Table.new(header: headers, rows: data)
    table = table.render(:ascii, padding: [0, 1, 0, 1])
  end

  def prepare_saved_data(data, headers)
    str = "Welcome to HangMan, here are the all saved games\n\n"
    data = set_relative_time(data, :last_played)
    table = convert_hash_to_table(data, headers)
    str << table
    str << "\n\nEnter S.no or 0 to go back: "
    str
  end
end
