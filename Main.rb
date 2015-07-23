# Yahtzee
Ruby text based Yahtzee game


class Dice
	attr_accessor :value
def initialize(value = 1)
	@value = value
end

end

class Yahtzee
	attr_reader :rolls
def initialize(diceArray)
	@inPlay = diceArray
	@outPlay  = []
	@rolls = 1
	@ender = 0
	@scorecard = Scorecard.new
end

private

def roll()
	if @rolls != 1
		print "which dice are you rolling?:"
		line = gets.chomp
		arr = line.split
		arr.each do |x|
			x = x.to_i
			@inPlay[x-1].value = rand(5)+1 
		end
	else 
	@inPlay.each do |x|
		x.value = rand(5)+1
	end
	end
	dispDice
	#@outPlay.each {|x| print "--[#{x.value}]-- "}
	puts ""
end

private

def dispDice()
	@inPlay.each {|x| print "[#{x.value}]"}
end
private


public

def menu()

while @ender == 0
	puts ""
	puts "1:Roll 2:Show Scorecard 3:Exit -- Roll# #{@rolls}"
	line = gets.chomp
	#line.to_i
	if line == "1"
		roll
		@rolls += 1
	elsif line == "3"
		@ender = 1
	elsif line == "2"
		@scorecard.disp
	end
	
	if @rolls > 3
		@rolls = 1
		score
	end
	if @scorecard.isFull?
		@ender == 1
	end
	
end
end

def score()
	error = true
	yaht = false
	@outPlay.each {|x| @inPlay.push(x)}
	@outPlay = []
	num = []
	i = 0
while error
	print "Which dice are you scoring?(1-5): "
	line = gets.chomp
	choice = line.split
	choice.each do |x|
		x = x.to_i
		x-=1
		num[i] = @inPlay[x].value 
		i+=1
	end
	
	if num[0]==num[1] && num[2]==num[1] && num[3]==num[4] && num.length == 5
		yaht = true
		puts "Yahtzee!"
		@scorecard.yahtzee
	end
	unless yaht
		num = num.sort
		if 1==1
			puts""
			print "1: Use Numbers? "	
		end
		if num.length == 3 && num[0] == num[1] && num[1] == num[2]
			print "2: 3 of a kind? "
		end
		if num.length == 4 && num[0] == num[1] && num[1] == num[2] && num[2] == num[3]
			print "3: 4 of a kind? "
		end
		if num.length == 5 && num[0] == num[1] && num[3] == num[4]
			print "4: Full House? "
		end
		if num.length == 4 && array_increments_by?(1, num)
			print "5: Small Straight? "
		end
		if num.length == 5 && array_increments_by?(1, num)
			print "6: Large Straight? "
		end
			print "7: Chance "
			print "8: Cross-Off"
		scorer = gets.chomp
	
		if scorer  == "1"
			@scorecard.numb(num)
		elsif scorer == "2"
			@scorecard.three(num)
		elsif scorer == "3"
			@scorecard.four(num)
		elsif scorer == "4"
			@scorecard.full
		elsif scorer == "5"
			@scorecard.small
		elsif scorer == "6"
			@scorecard.large
		elsif scorer == "7"
			@scorecard.chance(num)
		else
			@scorecard.cross
		end
	end
error = false
error = true if @scorecard.valid == false	
	
end
end

def array_increments_by?(step, array)
  sorted = array.sort
  lastNum = sorted[0]
  sorted[1, sorted.count].each do |n|
    if lastNum + step != n
      return false
    end
    lastNum = n
  end
  true
end

end

class Scorecard
	attr_reader :valid
def initialize()

	@ones = 0
	@twos = 0
	@threes = 0
	@fours = 0
	@fives = 0
	@sixes = 0
	@threeo = 0
	@fouro = 0
	@fullh = 0
	@smalls = 0
	@larges = 0
	@chanced = 0
	@yahtz = 0
	@valid = true
	
end	

def numb(num)
extra = true
if num[0] < num[num.length - 1]
	@valid = false
	puts "Not all the same number!"
end

if @valid
	if num[0] == 1	&& @ones == 0		
		@ones = num.length * 1 
	elsif num[0] == 2 && @twos == 0		
		@twos = num.length * 2 
	elsif num[0] == 3 && @threes == 0		
		@threes = num.length * 3 
	elsif num[0] == 4 && @fours == 0		
		@fours = num.length * 4
	elsif num[0] ==5 && @fives == 0		
		@fives = num.length * 5
	elsif num[0] ==6 && @sixes == 0		
		@sixes = num.length * 6
	else
		extra = true
		puts "Slot not empty! "
	end
	@valid = true if extra == false
end
end	

def three(num)
@valid = true
if @threeo == 0
	@threeo = num[0] * 3
else
	@valid = false
	puts "slot not empty"
end
end

def four(num)
@valid = true
if @fouro ==0
	@fouro = num[0] * 4
else
	@valid = false
	puts "Slot not empty"
end
end

def full()
@valid = true
	if @fullh == 0 
		@fullh = 25
	else
		@valid = false
		puts "Slot not empty"
	end
end

def small()
@valid = true
	if @smalls == 0 
		@smalls = 30
	else
		@valid = false
		puts "Slot not empty"
	end
end

def large()
@valid = true
	if @larges == 0 
		@larges = 40
	else
		@valid = false
		puts "Slot not empty"
	end
end

def chance(num)
@valid = true
	if @chanced == 0 
		num.each {|x| @chanced += x}
	else
		@valid = false
		puts "Slot not empty"
	end
end
def yahtzee()
x = 0
if @yahtz == 0
	@yahtz = 50
else
	puts "Which catagory are you placing it in?"
	if @threeo == 0
		print "1: 3 of a kind, "
		x=1
	end
	if @fouro == 0
		print"2: 4 of a kind, "
		x=1
	end
	if @fullh == 0
		print"3: Full house, "
		x=1
	end
	if @smalls == 0
		print"4: Small Straight, "
		x=1
	end
	if @larges == 0
		print"5: Large Straight, "
		x=1
	end
	if @chanced == 0
		print"6: Chance "
		x=1
	end
	if x == 0
		print "Cant use Yahtzee"
	end

	scorer = gets.chomp
	while x==1
		if scorer  == "1"
			@threeo = 100
			x=0
		elsif scorer == "2"
			@fouro = 100
			x=0
		elsif scorer == "3"
			@fullh =100
			x=0
		elsif scorer == "4"
			@smalls = 100
			x=0
		elsif scorer == "5"
			@larges = 100
			x=0
		elsif scorer == "6"
			@chance = 100
			x=0
		else
			print "nothing selected"
		end
	end
end
	
end
def cross()
	disp
end

def disp()
puts "1: Ones: #{@ones}"
puts "2: Twos: #{@twos}"
puts "3: Threes: #{@threes}"
puts "4: Fours: #{@fours}"
puts "5: Fives: #{@fives}"
puts "6: Sixes: #{@sixes}"
puts "7: 3 of a kind: #{@threeo}"
puts "8: 4 of a kind: #{@fouro}"
puts "9: Full House: #{@fullh}"
puts "10: Small Straight: #{@smalls}"
puts "11: Large Straight: #{@larges}"
puts "12: Yahtzee: #{@yahtz}"
puts "13: Chance: #{@chanced}"
end

def calculate()
num_total = @ones + @twos + @threes + @fours + @fives + @sixes
bottom_total  = @threeo + @fouro + @fullh + @smalls + @larges + @yahtz + @chanced
if num_total >= 63
	puts"Got the bonus 30 points"
	bigTotal = 30 + num_total + bottom_total
else
	bigTotal = num_total + bottom_total
end
	puts "Total Score: #{bigTotal}"

end



def isFull?()
	if @ones != 0 && @twos != 0 && @threes != 0 && @fours != 0 && @fives != 0 && @sixes != 0 && @threeo != 0 && @fouro != 0 && @fullh != 0 && @smalls != 0 && @larges != 0 && @yahtz != 0 && @chanced != 0 
		return true
	else
		return false
	end
end

end

d1 = Dice.new
d2 = Dice.new
d3 = Dice.new
d4 = Dice.new
d5 = Dice.new

diceArray = [d1,d2,d3,d4,d5]

game = Yahtzee.new (diceArray)

game.menu

#game.roll
