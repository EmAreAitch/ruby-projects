puts "Enter dictionary (use comma to separate)"
dict = gets.chomp.split(/\W+/);
puts "Enter String"
str = gets.chomp

def substrings(str,dict) 
    result = Hash.new(0)
    dict.each { |a|
        str.scan(/#{a}/i)
            result[a]+= 1
    }
    result
end

puts substrings(str,dict)
