print "Enter String: "
string = gets.chomp
print "Enter shift factor: "
mov = gets.chomp.to_i

def caesar_cipher(inStr,mov)
    outStr = '' #Declares empty string
    inStr.each_byte do |byte| #Loops through every character's ascii code
        chrBit = byte
        if byte.between?(65,90) #For lower case encoding
            chrBit = (((byte-65)+mov)%26)+65
        elsif byte.between?(97,122) #For upper case encoding
            chrBit = (((byte-97)+mov)%26)+97
        end
        outStr += chrBit.chr #Concatenates encoded character
    end 
    outStr #Returns final encoded string
end

puts "Encoded string: #{caesar_cipher(string,mov)}"