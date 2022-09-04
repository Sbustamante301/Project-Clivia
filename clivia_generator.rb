# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "httparty"
require "terminal-table"
require "json"
require "htmlentities"
require_relative "presenter"
require_relative "requester"

class CliviaGenerator
  # maybe we need to include a couple of modules?
include Presenter
include Requester


  def initialize
    # we need to initialize a couple of properties here
    @score = 0
    @player = nil
     
  end
  
  # coder = HTMLEntities.new
  # string = "&eacute;lan"
  # coder.decode(string) # => "élan"

  def start
    # welcome message
     presenter_message("#   Welcome to Clivia Generator   #")
     actions_menu
    # prompt the user for an action
    # keep going until the user types exit
  end

  def random_trivia
    # load the questions from the api
    # questions are loaded, then let's ask them
   
   questions_hash = load_questions
   questions_hash = questions_hash[:results]
   
   
   
    questions_hash.each do |question|
      request_answers(question)
      
      
    end
    puts "Well done! Your score is #{@score}"
    puts "-------------------------------------\nDo you want to save your score? (y/n)"
    print "> "
    no = ["n","N"]
    yes = ["y","Y"]
    choice = gets.chomp
    if no.include? choice
      presenter_message("#   Welcome to Clivia Generator   #")
    end
    if yes.include? choice
      puts "Type the name to assign to the score"
      print "> "
      @player = gets.chomp
    
    unless @player.empty? 
       @player = @player
    else
      @player = "Anonymous" 
    end
  end
  player_arr = [@player,@score]
  save(player_arr)
  end
  def request_answers(question)
     
    coder = HTMLEntities.new
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    puts  "Question: #{coder.decode(question[:question])}"
    question[:incorrect_answers].push(question[:correct_answer])
    
    question[:incorrect_answers].each_with_index do|answer,index|
      puts "#{index + 1}. #{coder.decode(answer)}"
    end
    print "> "
    answer = ""
    until question[:incorrect_answers].include? answer 
    answer = gets.chomp
    end
    print "#{answer}... "
    if answer == question[:correct_answer]
      @score += 10
      puts "Correct!"
        
    else puts "Incorrect!\nThe correct answer was: #{coder.decode(question[:correct_answer])} "
    end
    
    
  end

  def ask_questions
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  datos = data.join
   File.write("scores.json","#{datos}", mode: "a")
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    raise HTTParty::ResponseError, response unless response.success?
    
    coder = HTMLEntities.new
    string = response
    # decoded_question = coder.decode(string)
       
    JSON.parse(string.body, symbolize_names: true)
    # then parse the questions
  end

  def parse_questions
    
    # questions came with an unexpected structure, clean them to make it usable for our purposes
     # => "élan"
    
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
#   def table_values
#     total_array = []
#     @user_categories.each do |hash|
#         transactions_data = hash[:transactions]
#         amount_arr = transactions_data.map {|hash| hash[:amount]}
#         total = amount_arr.reduce(0) { |sum, n| sum + n }
#         total_array.push(total)
#     end
#     categories = @user_categories.map {|hash| [hash[:id], hash[:name]]}
#     @nueva_va = categories.each_with_index {|cat, index| cat.push(total_array[index])}
# end
def actions_menu
  action = ""
  until action == "exit"
      action = get_with_options(["random", "scores", "exit"])
      case action
      when "random" then  random_trivia
      when "scores" then puts "soy scores"
      when "exit"   then puts presenter_message("#   Thanks for using Clivia!      #")
  end
end
end
def get_with_options(options)
  action = ""
  until options.include?(action)
      puts options.join(" | ")
      print "> "
      action = gets.chomp
      puts "Invalid option" unless options.include?(action)
  end
  action
end 



end


trivia = CliviaGenerator.new
trivia.start
