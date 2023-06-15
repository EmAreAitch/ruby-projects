class MasterMind
    def initialize(name,digit,round,repeat=false)
        @player_name = name
        @max_digit = digit
        @max_round = round
        @repeat = repeat
        puts "Welcome #{name} to mastermind game"
    end
    def setRepeat= repeat
        @repeat = repeat
    end
    def ranGen
        @num = String.new
        for i in 1..@max_digit do
            j = rand(0..9).to_s
            if (@num.include?(j) && !@repeat) then redo else @num << j end
        end
    end
    def takeGuess
        for i in 1..@max_round do
            print "\nEnter your guess: "
            @usnum = gets.chomp.to_s
            if (@usnum == @num)
                return true
            end
            checkCor
        end
        return false
    end
    def checkCor 
        correct = 0
        corpos = 0
        @usnum.each_char.with_index do |i,j|
            if (@num[j] == @usnum[i])
                corpos += 1
            elsif (@num.include?(i))
                correct += 1
            end
        end
        puts "\nCorrect Number: #{correct} | Correct Position: #{corpos}"
    end
    def start
        ranGen
        puts "Code is generated #{@num}!!!! You can start making guesses sir.."
        if(takeGuess) then
            puts "\nCongrats #{@player_name}!!!  You guess it right"
        else
            puts "\nGAME OVER!!! THE NUMBER WAS #{@num}"
        end
        return "Computer"
    end
end

game = MasterMind.new("Rahib",5,12,true)
game.start