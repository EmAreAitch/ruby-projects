class Tictactoe
    attr_accessor :board
    def initialize(player1, player2)
        @board = [1,2,3,4,5,6,7,8,9]
        @player = Array.new
        @player[0] = Player.new(player1,"X")
        @player[1] = Player.new(player2,"O")
    end
    def start
        print "\nWelcome #{@player[0].name}(X) and #{@player[1].name}(O)\n\n"
        print "Press any key to start game...."
        gets
        loop do
            for i in 0...2 do
                system("clear")
                print "Player X: "+@player[0].name+" | Player O: "+@player[1].name+"\n\n"
                self.showboard
                num = @player[i].playerInp
                unless num and self.board.include?(num)
                    print "\nERRR!! Enter number present on board... "
                    gets
                    redo
                end
                symbol = @player[i].playersymbol
                self.chgboard(num,symbol)
                if(self.checkwin(num,symbol))
                    print "Player X: "+@player[0].name+" | Player O: "+@player[1].name+"\n\n"
                    print "\nPlayer " + @player[i].name + " WON!!!\n\n"
                    self.showboard
                    return @player[i].name
                end
            end
        end
    end
    def chgboard(num,symbol)
        ind = (self.board).index(num)
        if(ind!=nil)
            self.board[ind] = symbol
        end
        
    end
    def checkwin(num,symbol)
        win = 0
        rind = 0
        rind = 1 if num in 4..6
        rind = 2 if num in 7..9
        cind = 0
        cind = 1 if num % 3 == 2
        cind = 2 if num % 3 == 0
        for i in 0..2 do
            win = self.board[3 * rind + i] == symbol
            break unless win
        end
        return win if win
        for i in 0..2 do
            win = self.board[3 * i + cind] == symbol
            break unless win
        end
        return win if win
        if (rind + cind  == 2 && rind == cind)
            2.times do |i|
                ind = i * 2
                diff = 4-ind
                while (ind <= 8-i*2)
                    win = self.board[ind] == symbol
                    ind += diff
                    break unless win
                end
                return win if win
            end
        elsif (rind + cind == 2) 
            3.times do |i|
                win = self.board[2*(i+1)] == symbol
                break unless win
            end
            return win if win
        elsif (rind == cind)
            3.times do |i|
                win = self.board[4*i] == symbol
                break unless win
            end
            return win if win
        end
        return win
    end
    def markboard(arr)

    end
    def showboard 
        3.times do |i|
            if (i != 0)
                puts "─────────"
            end
            puts "#{@board[i*3]} | #{@board[i*3+1]} | #{@board[i*3+2]}"
        end
    end  
end
class Player < Tictactoe
    attr_accessor :name, :playerturn, :playersymbol 
    def initialize(player, playersymbol)
        @name = player
        @playercho =  Array.new
        @playersymbol = playersymbol
    end
    def playerInp 
        print "\n#{@name}'s turn (#{@playersymbol}),\n"
        print "Enter location: "
        inp = gets.chomp.to_i
        if (!(inp in 1..9))
            return false
        else
            @playercho.push(inp)
            return inp
        end
    end
end

print "Enter player 1 name: "
player1 = gets.chomp
print "Enter player 2 name: "
player2 = gets.chomp
game = Tictactoe.new(player1,player2)
game.start