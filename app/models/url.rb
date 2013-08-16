class Url < ActiveRecord::Base
	validates_presence_of :original_url, :status
	# validates :original_url, :uniqueness => true
	validates :shortened_extension, :uniqueness => true
	before_save :add_http
  before_save :generate_shortened_url_extension
  require 'securerandom'

  # private
  	def add_http
      url = self.original_url
      u = URI.parse(url)
      if (!u.scheme)
         self.original_url = "http://" + url
      end
    end

    def generate_shortened_url_extension
      if self.shortened_extension.blank?
        begin
            self.shortened_extension = SecureRandom.hex(2)
        end while not Url.find_by(:shortened_extension => self.shortened_extension).blank?
      end
    end
end
