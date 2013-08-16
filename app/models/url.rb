class Url < ActiveRecord::Base
	validates_presence_of :original_url, :status
	# validates :original_url, :uniqueness => true
	validates :shortened_url, :uniqueness => true
	before_save :add_http
  before_save :generate_shortened_url
  require 'securerandom'

  # private
  	def add_http
      url = self.original_url
      u = URI.parse(url)
      if (!u.scheme)
         self.original_url = "http://" + url
      end
    end

    def generate_shortened_url
      if self.shortened_url.blank?
        begin
            self.shortened_url = SecureRandom.hex(2)
        end while not Url.find_by(:shortened_url => self.shortened_url).blank?
      end
    end
end
