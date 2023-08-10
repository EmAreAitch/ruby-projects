# Abstract Interface for various GameStates
module GameState
  def [](key)
    @game_data[key]
  end

  def []=(key, value)
    @game_data[key] = value
  end

  def save
    raise NotImplementedError, "#{self.class} must implement save"
  end
end

# Module extending saving game functionality
module GameSave
  def save_file_info
    save_info = {
      dir: "save_file/",
      file: "saves.csv",
      headers: ["S.no", "Player", "Difficulty", "Score - Max", "Round - Max", "Last played"],
    }
    save_info[:full_path] = save_info[:dir] + save_info[:file]
    save_info
  end

  def headers_exist?(csv_file_path, headers)
    first_row = nil
    CSV.foreach(csv_file_path) do |row|
      first_row = row
      break
    end
    return first_row == headers
  end

  def ensure_save_file
    save = save_file_info()
    Dir.mkdir(save[:dir]) unless Dir.exist?(save[:dir])

    unless File.exist?(save[:full_path])
      CSV.open(save[:full_path], "w") do |csv|
        csv << save[:headers]
      end
    else
      unless headers_exist?(save[:full_path], save[:headers])
        file_content = File.read(save[:full_path])
        new_content = save[:headers].to_csv + file_content
        new_content += "\n" unless new_content.end_with? "\n"
        File.write(save[:full_path], new_content, mode: "r+")
      end
    end
  end

  def read_save_data()
    ensure_save_file()
    path = save_file_info[:full_path]
    CSV.read(path, headers: true, header_converters: :symbol).map(&:to_h).reject(&:empty?)
  end
end


# New Game State handling saving and initialization of a newgame
class HangManNewGame
  include GameState
  include GameSave

  def initialize(name, difficulty)
    @game_data = {
      player_name: name,
      difficulty: difficulty[:name],
      score: 0, max_score: 0,
      round: 1, max_round: 1,
    }
  end

  def save()
    number_of_saves = read_save_data().length
    save_info = save_file_info()
    record = Array.new
    record << number_of_saves + 1 << self[:player_name] << self[:difficulty] << "#{self[:score]} - #{self[:max_score]}" << "#{self[:round]} - #{self[:max_round]}" << (Time.now).to_s
    CSV.open(save_info[:full_path], "a") do |csv|
      csv << record
    end
  end
end


# Load Game State handling saving and initialization of a Loaded Game
class HangManLoadGame
  include GameState
  include GameSave

  def initialize(data, user_save_choice)
    @game_data = extract_data(data[user_save_choice - 1])
    @save_choice = user_save_choice
  end

  def extract_data(save_data_record)
    score, max_score = save_data_record[:score_max].split("-").map { |i| i.strip.to_i }
    round, max_round = save_data_record[:round_max].split("-").map { |i| i.strip.to_i }
    game_data = {
      player_name: save_data_record[:name],
      difficulty: save_data_record[:difficulty],
      score: score, max_score: max_score,
      round: round, max_round: max_round,
    }
    game_data
  end

  def save()
    data = read_save_data()
    save_info = save_file_info()
    data[@save_choice - 1][:score_max] = "#{self[:score]} - #{self[:max_score]}"
    data[@save_choice - 1][:round_max] = "#{self[:round]} - #{self[:max_round]}"
    data[@save_choice - 1][:last_played] = Time.now
    CSV.open(save_info[:full_path], "w", write_headers: true, headers: save_info[:headers]) do |csv|
      data.each do |hash|
        csv << hash.values
      end
    end
  end
end
