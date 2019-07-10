class ShortLink < ApplicationRecord
  SHORT_URL_LENGTH = 6.freeze
  
  has_secure_token :uuid
  
  before_save :generate_short_url

  validates :original_url, presence: true
  validates :short_url, presence: true, on: :save
  validates :uuid, presence: true, on: :save
  validates_format_of :original_url, with: /https?:\/\/[\S]+/

  def to_param
    self.uuid
  end

  private

  def generate_short_url
    begin
      url = new_url
    end while ShortLink.where(short_url: url).exists?
    self.short_url = url
  end

  def new_url
    charset = [*('A'..'Z'), *('a'..'z'), *('0'..'9')]
    Array.new(SHORT_URL_LENGTH) { charset.sample }.join
  end
end
