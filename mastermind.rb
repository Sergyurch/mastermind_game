class Game
  def initialize
    @round_results = []
    @combination
    display_rules
    start
  end
  
  def display_rules
    puts 'HOW TO PLAY MASTERMIND'.cyan
    puts ''
    sleep 1
    puts '1 - You have to break a secret code in order to win the game.'
    sleep 1
    puts ''
    puts "2 - You have 4 rounds to crack the code. In each round you will input what you think is the secret code."
    puts ''
    sleep 1
    puts '3 - After submitting your code. The computer will try to help you to crack the code by giving hints as to correct digits, incorrect digits and correct digits that are in the incorrect position.'
    puts ''
    sleep 1
    puts 'HINTS'.cyan
    puts ''
    sleep 1
    puts '>>> If you get a digit absolutely correct, the digit will be coloured ' + 'green'.green + '.'
    sleep 1
    puts ''
    puts '>>> If you get a digit correct but in the wrong position, the digit will be coloured' +' white.'.white
    sleep 1
    puts ''
    puts '>>> If you get the digit wrong, the digit will be coloured ' + 'red'.red + '.'
    sleep 1
    puts ''
    puts 'For Example'.cyan
    sleep 1
    puts 'If the secret code is:'
    puts '1234'
    sleep 1
    puts 'and your guess was:'
    puts '1524'
    sleep 1
    puts 'you will see the following result:'
    sleep 1
    print '1'.green
    sleep 1
    print '5'.red
    sleep 1
    print '2'.white
    sleep 1
    print '4'.green
    sleep 1
    puts ''
    puts ''
    sleep 1
    puts 'LET THE GAME BEGIN'.cyan
    puts ''
    puts "Each digit should be between 1 and 6".cyan
    sleep 1
    puts "You have 4 rounds in which to guess the correct 4 digit combination".cyan
    puts "You will be playing with the computer".cyan
    puts ''
    puts ''
  end
  
  def start
    puts 'Would you like to be a Guesser or a Creator of the secret code?'
    puts 'Answers:'
    puts '1 - Guesser'
    puts '2 - Creator'
    puts 'Choose your variant'
    answer = gets.chomp
    
    until answer.match?(/[1,2]/)
      puts "Enter only \'1\' or \'2\'"
      answer = gets.chomp
    end
    
    if answer == '1'
      @secret_code = rand(1..6).to_s + rand(1..6).to_s + rand(1..6).to_s + rand(1..6).to_s
      player_is_guesser
    else
      puts 'Enter a secret code'
      @secret_code = gets.chomp
      check_combination(@secret_code)
      computer_is_guesser
    end
    
  end
  
  protected
  
  def player_is_guesser
    4.times do
      puts 'Enter your combination'
      @combination = gets.chomp
      check_combination(@combination)
      paint_digits
      show_round_results
      break if guesser_won?
    end
    
    puts (guesser_won?) ? 'You won!': 'You lost!'
    (play_again?) ? start: return
  end
  
  def computer_is_guesser
    set_of_digits = ['1','2','3','4','5','6']
    current_digit_index = 0
    wrong_place_digits = [[], [], [], []]
    @combination = 'XXXX'
    4.times do
      for i in 0..3
        if @combination[i] == 'X'
          while wrong_place_digits[i].include?(set_of_digits[current_digit_index]) do
            if current_digit_index == set_of_digits.length - 1
              current_digit_index = 0
            else
              current_digit_index += 1
            end
          end
          @combination[i] = set_of_digits[current_digit_index]
          if current_digit_index == set_of_digits.length - 1
            current_digit_index = 0
          else
            current_digit_index += 1
          end
        end
      end
      
      paint_digits
      
      for i in 0..3
        if @combination[i] == @secret_code[i]
          last = set_of_digits.delete(@combination[i])
          set_of_digits.push(last)
          current_digit_index -= 1 if current_digit_index != 0
        elsif @secret_code.include? @combination[i]
          wrong_place_digits[i].push(@combination[i])
          first = set_of_digits.delete(@combination[i])
          set_of_digits.unshift(first)
          @combination[i] = 'X'
          current_digit_index = 0
        else
          set_of_digits.delete(@combination[i])
          @combination[i] = 'X'
          current_digit_index -= 1 if current_digit_index != 0
        end
      end
      
      show_round_results
      break if guesser_won?
    end
    
    puts (guesser_won?) ? 'Computer won!': 'Computer lost!'
    (play_again?) ? start: return
  end
  
  def check_combination(combination)
    until combination.match?(/[1-6][1-6][1-6][1-6]/)
      puts "Enter only 4 digit code. Use only 1-6 digits"
      combination = gets.chomp
    end
  end
  
  def paint_digits
    for i in 0..3
      if @combination[i] == @secret_code[i]
        @round_results.push(@combination[i].green)
      elsif @secret_code.include? @combination[i]
        @round_results.push(@combination[i].white)
      else
        @round_results.push(@combination[i].red)
      end
    end
  end
  
  def show_round_results
    puts 'Round results'
    
    for i in 0..3
      print @round_results[i]
    end
    
    puts ''
    @round_results = []
  end
  
  def guesser_won?
    return (@combination == @secret_code) ? true: false
  end
  
  def play_again?
    puts 'Would you like to play again?(Y/N)'
    answer = gets.chomp
    
    until answer.match?(/[Y,y,N,n]/)
      puts "Enter \'Y\' or \'N\', please"
      answer = gets.chomp
    end
    
    return (answer.match?(/[Y,y]/)) ? true: false
  end
  
end

class String
  def red;            "\e[31m#{self}\e[0m"; end
  def green;          "\e[32m#{self}\e[0m"; end
  def cyan;           "\e[36m#{self}\e[0m"; end
  def white;           "\e[37m#{self}\e[0m"; end
end

Game.new