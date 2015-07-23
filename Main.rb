# Yahtzee
Ruby text based Yahtzee game


class Place
	attr_reader :value
	attr_accessor :crossed
def initialize()
	@value = 0
	@crossed = false
end

def valueSet(num)
	if @crossed == false
		@value = num
	else
		@value = 0
	end
end

def valueShow()
	if @crossed
		return "X"
	else
		return @value
	end
end
end

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
	@start = 0
end

private

def roll()
valid = true
while valid
	if @rolls != 1
		print "which dice are you rolling?: (0 for none) "
		line = gets.chomp
		arr = line.split
	
		arr.each do |x|
			x = x.to_i
			if x <= 5
				@inPlay[x-1].value = rand(6)+1 
				valid = false
			else
				valid = true
			end
		end
	#if arr[0] != "0"
	#puts "here"
		#@rolls = 3
	#else
		#arr.each do |x|
			#x = x.to_i
			#@inPlay[x-1].value = rand(6)+1 
		#end
	#end
	else 
	@inPlay.each do |x|
		x.value = rand(6)+1
		valid = false
	end
end
end
	dispDice
	#@outPlay.each {|x| print "--[#{x.value}]-- "}
	puts ""
end

private

def dispDice()
	puts""
	@inPlay.each {|x| print "[#{x.value}]"}
	puts ""
	puts ""
end

def howTo
	puts "1: Roll Dice which have values one to six"
	puts "2: When entering multiple numbers seperate them with spaces ex 1 2 3 "
	puts "3: To recieve the bonus your number scores must total 63"
	puts "4: A Yahtzee is achieved when all 5 dice are the same number" 
	puts "   the first Yahtzee is 50 points then each subseqent is 100 and must be placed    in another tile"
end
public

def menu()
g = true
if @start == 0
	@start = 1
	
	while g   
	puts ""           
	printf" \\ \\ / /_ _| |__ | |_ _______  ___ "
	puts ""  
	printf"  \\ V / _` | '_ \\| __|_  / _ \\/ _ \\"
	puts ""  
	printf"   | | (_| | | | | |_ / /  __/  __/"
	puts ""  
	printf"   |_|\\__,_|_| |_|\\__/___\\___|\\___|"
	puts ""  
	puts ""
	print "	1:Start 2:How to play -- "
	it = gets.chomp
	if it == "2"
		howTo
	else
		g = false
	end
end
end
while @ender == 0
	print "1:Roll 2:Score Dice 3:Show Scorecard 4:Exit -- Roll# #{@rolls}  "
	line = gets.chomp
	#line.to_i
	if line == "1"
		roll
		@rolls += 1
	elsif line == "2"
		hold
	elsif line == "3"
		@scorecard.disp
	elsif line == "4"
		@ender = 1
	end
	
	if @rolls > 3
		@rolls = 1
		score
	end
	if @scorecard.isFull
		@scorecard.disp
		@scorecard.calculate
		@ender = 1
	end
end
end

def hold
	@rolls = 4
end

def score()
	@scorecard.disp
	dispDice
	error = true
	yaht = false
	@outPlay.each {|x| @inPlay.push(x)}
	@outPlay = []
	num = []
	i = 0
while error
	loop = true
	while loop
	i = 0
	print "Which dice are you scoring?(1-5): "
	line = gets.chomp
	choice = line.split
	choice.each do |x|
		x = x.to_i
	if x < 6
		x-=1
		num[i] = @inPlay[x].value 
		i+=1
		loop = false
	end
	loop = true if i < choice.length
	end
	end
	
	if num[0]==num[1] && num[2]==num[0] && num[3]==num[0] && num[4]==num[0] && num.length == 5
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
			print "8: Cross-Off "
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
20.times{puts""}
printf"     __          _  	____				   "
puts ""
printf"  /\\ \\ \\_____  _| |_  /__   \\_   _ _ __ _ __  "
puts ""
printf" /  \\/ / _ \\ \\/ / __|   / /\\/ | | | '__| '_ \\ "
puts ""
printf"/ /\\  /  __/>  <| |_   / /  | |_| | |  | | | |"
puts""
printf"\\_\\ \\/ \\___/_/\\_\\\\__|  \\/    \\__,_|_|  |_| |_|"
puts ""
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

	@ones = Place.new
	@twos = Place.new
	@threes = Place.new
	@fours = Place.new
	@fives = Place.new
	@sixes = Place.new
	@threeo = Place.new
	@fouro = Place.new
	@fullh = Place.new
	@smalls = Place.new
	@larges = Place.new
	@chanced = Place.new
	@yahtz = Place.new
	@valid = true
	
end	

def numb(num)
extra = true
if num[0] < num[num.length - 1] && num.length >1
	@valid = false
	puts "Not all the same number!"
end

if @valid
	if num[0] == 1	&& @ones.valueShow == 0		
		@ones.valueSet(num.length * 1)
	elsif num[0] == 2 && @twos.valueShow == 0		
		@twos.valueSet(num.length * 2) 
	elsif num[0] == 3 && @threes.valueShow == 0		
		@threes.valueSet(num.length * 3) 
	elsif num[0] == 4 && @fours.valueShow == 0		
		@fours.valueSet(num.length * 4)
	elsif num[0] ==5 && @fives.valueShow == 0		
		@fives.valueSet(num.length * 5)
	elsif num[0] ==6 && @sixes.valueShow == 0		
		@sixes.valueSet(num.length * 6)
	else
		extra = true
		puts "Slot not empty! "
	end
	@valid = true if extra == false
end
end	

def three(num)
@valid = true
if @threeo.valueShow == 0
	@threeo.valueSet(num[0] * 3)
else
	@valid = false
	puts "slot not empty"
end
end

def four(num)
@valid = true
if @fouro.valueShow ==0
	@fouro.valueSet(num[0] * 4)
else
	@valid = false
	puts "Slot not empty"
end
end

def full()
@valid = true
	if @fullh.valueShow == 0 
		@fullh.valueSet(25)
	else
		@valid = false
		puts "Slot not empty"
	end
end

def small()
@valid = true
	if @smalls.valueShow == 0 
		@smalls.valueSet(30)
	else
		@valid = false
		puts "Slot not empty"
	end
end

def large()
@valid = true
	if @larges.valueShow == 0 
		@larges.valueSet(40)
	else
		@valid = false
		puts "Slot not empty"
	end
end

def chance(num)
@valid = true
total = 0
	if @chanced.valueShow == 0 
		num.each {|x| total += x}
		@chanced.valueSet(total)
	else
		@valid = false
		puts "Slot not empty"
	end
end

def yahtzee()
x = 0
if @yahtz.valueShow == 0
	@yahtz.valueSet(50)
else
	puts "Which catagory are you placing it in?"
	if @threeo.valueShow == 0
		print "1: 3 of a kind, "
		x=1
	end
	if @fouro.valueShow == 0
		print"2: 4 of a kind, "
		x=1
	end
	if @fullh.valueShow == 0
		print"3: Full house, "
		x=1
	end
	if @smalls.valueShow == 0
		print"4: Small Straight, "
		x=1
	end
	if @larges.valueShow == 0
		print"5: Large Straight, "
		x=1
	end
	if @chanced.valueShow == 0
		print"6: Chance "
		x=1
	end
	if x == 0
		print "Cant use Yahtzee"
	end
	print"7: Cross off? "

	scorer = gets.chomp
	while x==1
		if scorer  == "1"
			@threeo.valueSet(100)
			x=0
		elsif scorer == "2"
			@fouro.valueSet(100)
			x=0
		elsif scorer == "3"
			@fullh.valueSet(100)
			x=0
		elsif scorer == "4"
			@smalls.valueSet(100)
			x=0
		elsif scorer == "5"
			@larges.valueSet(100)
			x=0
		elsif scorer == "6"
			@chance.valueSet(100)
			x=0
		elsif scorer == "7"
			cross
		else
			print "nothing selected"
		end
	end
end
	
end

def cross()
	disp
	print "Which catagory will you cross off? "
	line= gets.chomp
	if line == "1"
		@ones.crossed = true
	elsif line == "2"
		@twos.crossed  = true
	elsif line == "3"
		@threes.crossed  = true
	elsif line == "4"
		@fours.crossed  = true
	elsif line == "5"
		@fives.crossed  = true
	elsif line == "6"
		@sixes.crossed  = true
	elsif line == "7"
		@threeo.crossed  = true
	elsif line == "8"
		@fouro.crossed  = true
	elsif line == "9"
		@fullh.crossed  = true
	elsif line == "10"
		@smalls.crossed  = true	
	elsif line == "11"
		@larges.crossed  = true
	elsif line == "12"
		@yahtz.crossed  = true
	elsif line == "13"
		@chanced.crossed  = true
	else
		puts "Nothing Selected"
	end
	@valid = true
end

def disp()
puts"	SCORECARD"
puts "1: Ones: #{@ones.valueShow}"
puts "2: Twos: #{@twos.valueShow}"
puts "3: Threes: #{@threes.valueShow}"
puts "4: Fours: #{@fours.valueShow}"
puts "5: Fives: #{@fives.valueShow}"
puts "6: Sixes: #{@sixes.valueShow}"
puts"   -------------"
puts "7: 3 of a kind: [#{@threeo.valueShow}]"
puts"   -------------"
puts "8: 4 of a kind: [#{@fouro.valueShow}]"
puts"   -------------"
puts "9: Full House: [#{@fullh.valueShow}]"
puts"   -------------"
puts "10: Small Straight: [#{@smalls.valueShow}]"
puts"   -------------"
puts "11: Large Straight: [#{@larges.valueShow}]"
puts"   -------------"
puts "12: Yahtzee: [#{@yahtz.valueShow}]"
puts"   -------------"
puts "13: Chance: [#{@chanced.valueShow}]"
end

def calculate()
num_total = @ones.value + @twos.value + @threes.value + @fours.value + @fives.value + @sixes.value
bottom_total  = @threeo.value + @fouro.value + @fullh.value + @smalls.value + @larges.value + @yahtz.value + @chanced.value
if num_total >= 63
	puts"Got the bonus 30 points"
	bigTotal = 30 + num_total + bottom_total
else
	bigTotal = num_total + bottom_total
end
	puts "Total Score: #{bigTotal}"

end

def isFull()
count = 0
arr = [@ones.valueShow, @twos.valueShow, @threes.valueShow, @fours.valueShow, @fives.valueShow, @sixes.valueShow, @threeo.valueShow,@fouro.valueShow,@fullh.valueShow,@smalls.valueShow,@larges.valueShow,@yahtz.valueShow,@chanced.valueShow]
arr.each do |x|
	if x != 0 || x == "X"
		count +=1
	end
end
return true if count >=13
return false

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
