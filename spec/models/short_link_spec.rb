require 'rails_helper'

RSpec.describe ShortLink, type: :model do
  let(:short_link) { FactoryBot.create :short_link }

  describe 'field validations' do
    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_presence_of(:short_url).on(:save) }
    it { is_expected.to validate_presence_of(:uuid).on(:save) }
    it { is_expected.to allow_value("https://www.test.com/s/123").for(:original_url) }
    it { is_expected.to_not allow_value("htpp://www/123").for(:original_url) }
    it { is_expected.to respond_to(:expired) }
    it { is_expected.to respond_to(:view_count) }
  end
end
