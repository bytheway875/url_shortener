class Url < ActiveRecord::Base
	validates_presence_of :original_url, :status
	validates :shortened_extension, :uniqueness => true
	before_save :add_http
  before_save :generate_url_extension
  require 'securerandom'

  def add_http
    url = self.original_url
    u = URI.parse(url)
    self.original_url = "http://" + url unless u.scheme
  end

  def generate_url_extension
    if self.shortened_extension.blank?
      begin
          self.shortened_extension = SecureRandom.hex(3)
      end until Url.find_by(shortened_extension: self.shortened_extension).blank?
    end
  end
end
