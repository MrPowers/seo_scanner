class UrlEvaluator

  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def assess
    checks.inject([]) do |memo, (check, description)|
      memo.push([check, description]) if send(check)
      memo
    end
  end

  def checks
    {
      h1_missing: "h1 tag should describe site content",
      multiple_h1s: "There should only be one h1 tag on a page",
      keyword_stuffed_h1: "Keywords are being stuffed into the h1 tag",
      title_missing: "A page should have a title",
      multiple_titles: "A page should only have one title",
      long_title: "Titles should generally be less than 70 characters so search engines don't need to truncate them.  Your title is #{title_characters} characters: \"#{titles_text}\".",
      keyword_stuffed_title: "Keywords are being stuffed into the title tag",
      similar_h1_and_title: "The h1 tag and page title are too similar.  h1: \"#{h1_text}\", title: \"#{titles_text}\"",
      meta_description_missing: "The meta description is missing",
      long_meta_description: "Meta descriptions should be less than 160 characters"
    }
  end

  def keyword_stuffed_h1
    h1_count_by_word.length > 0
  end

  def h1_count_by_word
    k = KeywordStuffer.new(words: h1_text)
    k.count_by_word.select do |word, count|
      count > 1
    end
  end

  def h1_text
    return nil if h1s.empty?
    h1s.first.text
  end

  def keyword_stuffed_title
    title_count_by_word.length > 0
  end

  def title_count_by_word
    k = KeywordStuffer.new(words: titles_text)
    k.count_by_word.select do |word, count|
      count > 1
    end
  end

  def titles_text
    return nil if titles.empty?
    titles.text
  end

  def title_characters
    return nil if titles_text.nil?
    titles_text.length
  end

  def h1_missing
    h1s.length == 0
  end

  def multiple_h1s
    h1s.length > 1
  end

  def title_missing
    titles.length == 0
  end

  def multiple_titles
    titles.length > 1
  end

  def long_title
    titles_text.length > 70
  end

  def similar_h1_and_title
    return false if title_h1_similarity == false
    title_h1_similarity > 50
  end

  def meta_description_missing
    meta_descriptions.length == 0
  end

  def long_meta_description
    return false if meta_descriptions.empty?
    meta_descriptions.first["content"].length > 160
  end

  def doc
    @doc ||= Nokogiri::HTML(open(url))
  end

  def h1s
    @h1s ||= doc.xpath("//h1")
  end

  def h2s
    @h2s ||= doc.xpath("//h2")
  end

  def titles
    @titles ||= doc.xpath("//title")
  end

  def title_h1_similarity
    return false if h1s.empty?
    return false if titles.empty?
    titles_text.similar(h1_text)
  end

  def meta_descriptions
    doc.xpath("//meta[@name='description']")
  end

end

# e = UrlEvaluator.new(url: 'https://onlinetaxman.com/')
# e = UrlEvaluator.new(url: 'http://www.colombiaimmersion.com/')
# e = UrlEvaluator.new(url: 'http://www.hamsterdance.org/hamsterdance/')

