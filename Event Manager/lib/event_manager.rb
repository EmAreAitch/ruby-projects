require "csv"
require "google/apis/civicinfo_v2"
require "erb"
require "time"
require "date"

puts "Event Manager Initialized!"

contents = CSV.open(
  "Event Manager/event_attendees.csv",
  headers: true,
  header_converters: :symbol,
)

template_letter = File.read('Event Manager/form.erb')
erb_template = ERB.new template_letter

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislator_data(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"
  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: "country",
      roles: ["legislatorUpperBody", "legislatorLowerBody"],
    )
    legislators = legislators.officials
  rescue
    legislators = "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
  return legislators
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('Event Manager/output') unless Dir.exist?('Event Manager/output')

  filename = "Event Manager/output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def valid_number(number)
  number = number.delete('^0-9').to_i
  if(number >= 1e9 && number <2e10) 
    return (number % 1e10).to_i
  else 
    return 'N/A'
  end
end
def hour_to_arr(contents, symbol, tformat) 
  res = Array.new
  contents.rewind
  contents.each do |row|
    time = Time.strptime(row[symbol],tformat)
    hour = time.hour
    res.push(hour)
  end
    return res
end

def days_to_arr(contents, symbol, tformat) 
  res = Array.new
  contents.rewind
  contents.each do |row|
    time = Time.strptime(row[symbol],tformat).wday
    day = Date::DAYNAMES[time]
    res.push(day)
  end
    return res
end

def best_hour(hours) 
  return hours.max {|a,b| hours.count(a) <=> hours.count(b)}
end

def best_day(days) 
  return days.max {|a,b| days.count(a) <=> days.count(b)}
end

hours = hour_to_arr(contents, :regdate, "%D %H:%M")
days = days_to_arr(contents, :regdate, "%D %H:%M")
puts best_hour(hours)
puts best_day(days)

