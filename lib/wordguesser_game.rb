class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word

  def guess(letter)
    if letter == '' || letter == nil || letter !~ /[a-zA-Z]/
      raise ArgumentError
    end
    letter.downcase!
    if word.include?(letter) && !guesses.include?(letter)
      @guesses += letter
    elsif !word.include?(letter) && !wrong_guesses.include?(letter)
      @wrong_guesses += letter
    else
      return false
    end
  end

  def word_with_guesses
    blanks = ''
    @word.each_char do |letter|
      if guesses.include?(letter)
        blanks += letter.to_s
      else
        blanks += '-'
      end
    end
    return blanks
  end

  def check_win_or_lose
    if self.word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end
