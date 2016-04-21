class WebpageAssessor < ActiveRecord::Base

  validate :url_format_valid
  validates :email, email: true

  def url_format_valid
    unless valid_url?
      errors.add(:url, "URL format is invalid")
    end
  end

  def valid_url?
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end

end
