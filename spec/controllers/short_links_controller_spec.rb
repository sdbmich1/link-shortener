require 'rails_helper'

RSpec.describe ShortLinksController, type: :controller do
  render_views

  let(:params) { {} }
  let(:expired) { false }
  let!(:url) { 'https://test.com/s/123' }
  let!(:short_link) { FactoryBot.create :short_link, original_url: url, expired: expired }

  shared_examples_for 'not found page' do
    it 'returns correct status' do
      expect(response.status).to eq(404)
    end

    it 'does not increment counter' do
      expect(ShortLink.where(short_url: short_url).any?).to eq false
    end
  end

  describe '#index' do
    let!(:request) { get :index, params: params }

    context 'when valid url is passed' do
      let(:short_url) { short_link.short_url }
      let!(:params) { { short_url: short_url } }

      it 'returns correct status' do
        expect(response.status).to eq(302)
      end

      it 'increments counter' do
        expect(ShortLink.where(short_url: short_url).first.view_count).to eq 1
      end
    end
    context 'when id is not found' do
      let(:short_url) { SecureRandom.hex(3) }
      let!(:params) { { short_url: short_url } }

      it_behaves_like 'not found page'
    end
    context 'when url is expired' do
      let(:short_url) { short_link.short_url }
      let!(:expired) { true }
      let!(:params) { { short_url: short_url } }

      it 'returns correct status' do
        expect(response.status).to eq(404)
      end

      it 'does not increment counter' do
        expect(ShortLink.where(short_url: short_url).first.view_count).to eq 0
      end
    end
  end

  describe '#new' do
    let!(:request) { get :new }

    it 'returns correct status' do
      expect(response.status).to eq(200)
    end
  end

  describe '#create' do
    let!(:request) { post :create, params: params }

    context 'when valid url is passed' do
      let!(:url) { 'https://google.com' }
      let!(:params) { { short_link: { original_url: url } } }

      it 'returns correct status' do
        expect(response.status).to eq(302)
      end

      it 'creates a short link record' do
        expect(ShortLink.where(original_url: url).count).to eq 1
      end
    end
    context 'when url exists' do
      let!(:params) { { short_link: { original_url: url } } }

      it 'returns correct status' do
        expect(response.status).to eq(302)
      end

      it 'does not create a short link record' do
        expect(ShortLink.where(original_url: url).count).not_to eq 2
      end
    end
    context 'when url is invalid' do
      let(:new_url) { 'htpps://test.com/s/123' }
      let!(:params) { { short_link: { original_url: new_url } } }

      it 'returns correct status' do
        expect(response.status).not_to eq(302)
      end

      it 'does not create a short link record' do
        expect(ShortLink.where(original_url: new_url).count).not_to eq 1
      end
    end
  end

  describe '#show' do
    let!(:request) { get :show, params: params }
    context 'when valid uuid is passed' do
      let(:id) { short_link.id }
      let!(:params) { { id: id } }

      it 'returns correct status' do
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid uuid is passed' do
      let(:id) { 0 }
      let!(:params) { { id: id } }

      it 'returns correct status' do
        expect(response.status).not_to eq(200)
      end
    end

  end

  describe '#update' do
    let!(:request) { patch :update, params: params }
    context 'when valid attributes are passed' do
      let!(:params) { { id: short_link.id, short_link: { expired: true } } }

      it 'returns correct status' do
        expect(response.status).to eq(302)
      end

      it 'changes status' do
        expect(ShortLink.where(id: short_link.id).first.expired).to be true
      end
    end
    context 'when invalid attributes are passed' do
      let!(:params) { { id: short_link.id, short_link: { expired: nil } } }

      it 'returns correct status' do
        expect(response.status).to eq(302)
      end

      it 'changes status' do
        expect(ShortLink.where(id: short_link.id).first.expired).not_to be true
      end
    end
  end

  describe '#edit' do
    let!(:request) { get :edit, params: params }

    context 'when valid uuid is passed' do
      let(:id) { short_link.uuid }
      let!(:params) { { id: id } }

      it 'returns correct status' do
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid uuid is passed' do
      let(:id) { SecureRandom.uuid }
      let!(:params) { { id: id } }

      it 'returns correct status' do
        expect(response.status).not_to eq(200)
      end
    end
  end
end
