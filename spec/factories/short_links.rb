FactoryBot.define do
  factory :short_link do
    original_url  { Faker::Internet.url }
    short_url { "http://localhost/s/#{SecureRandom.hex(3)}" }
    uuid { SecureRandom.uuid }
    expired { false }
    view_count { 0 }
  end
end
