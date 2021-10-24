# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ExtractLocale do
  let(:service) { described_class.new }
  let(:params) { { path: 'index' } }
  let(:locales) { [:en, :fr]}
  subject { service.call(params: params, locales: locales) }

  context "the path doesn't contain a locale" do
    it "uses the default locale" do
      subject      
      expect(Translatable.current_locale).to eq(:en)
    end
    it "doesn't modify the path" do
      subject
      expect(params[:path]).to eq 'index'
    end
  end

  context 'the page contains the locale' do
    context 'the locale is not among the available locales' do
      let(:params) { { path: 'de/index' } }
      it 'uses the default locale' do
        expect(Translatable).to receive(:'current_locale=').with(:en)
        subject      
      end
      it "doesn't modify the path" do
        subject
        expect(params[:path]).to eq 'de/index'
      end
    end

    context 'the locale is among the available locales' do
      let(:params) { { path: 'fr/about-us' } }
      it 'removes the locale from the path' do
        expect(Translatable).to receive(:'current_locale=').with('fr')
        subject
        expect(params[:path]).to eq 'about-us'
      end
      context 'the path only contains the locale' do
        let(:params) { { path: 'fr' } }
        it 'replaces the path with index' do          
          expect(Translatable).to receive(:'current_locale=').with('fr')
          subject
          expect(params[:path]).to eq 'index'
        end
      end
    end
  end
end
