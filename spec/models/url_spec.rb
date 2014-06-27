require 'rails_helper'

describe Url do
  describe '#add_http' do
    it 'should prepend http:// if it is not part of the original url' do
      url = Url.new(original_url: "facebook.com")
      url.add_http
      expect(url.original_url).to eq "http://facebook.com"
    end

    it 'should not affect the original url if another valid scheme already exists' do
      url = Url.new(original_url: "aaa://facebook.com")
      url.add_http
      expect(url.original_url).to eq "aaa://facebook.com"
    end

    it 'should call this method as a before_save callback' do
      url = Url.new(original_url: "facebook.com")
      url.save
      expect(url.original_url).to eq "http://facebook.com"
    end
  end

  describe "#generate_url_extension" do
    it 'should create a random url extension' do
      url = Url.new(original_url: "http://facebook.com")
      url.generate_url_extension
      expect(url.shortened_extension).to be_present
    end

    it 'should call this method as a before_save callback' do
      url = Url.new(original_url: "http://facebook.com")
      url.save
      expect(url.shortened_extension).to be_present
    end
  end
end