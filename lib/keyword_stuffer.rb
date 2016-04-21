class KeywordStuffer

  attr_reader :words

  def initialize(words:)
    @words = words
  end

  def sanitized_words
    words.downcase.gsub(/[^0-9a-z ]/i, '')
  end

  def count_by_word
    return nil if words.nil?
    h = Hash.new(0)
    w = sanitized_words.split
    unique_words = w.uniq
    unique_words.each do |word|
      h[word] = sanitized_words.scan(/#{Regexp.quote(word)}/).length
    end
    h.sort_by {|k, v| v}.reverse
  end

end

# k = KeywordStuffer.new(words: "Expat Taxes, Expat Tax Services, Expatriate Tax Services | Online Taxman")
