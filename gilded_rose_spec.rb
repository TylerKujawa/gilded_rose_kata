require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'pry'

describe GildedRose do
  describe '#update_quality' do
    let(:name) { 'normal item' }
    let(:sell_in) { 10 }
    let(:quality) { 50 }
    let(:item) { Item.new(name, sell_in, quality) }
    let(:items) { [item] }
    let(:gilded_rose) { GildedRose.new(items) }

    before do
      gilded_rose.update_quality
    end

    it 'decreases the quality' do
      expect(item.quality).to eq 49
    end

    it 'decreases the sell in date' do
      expect(item.sell_in).to eq 9
    end

    context 'expired item' do
      let(:sell_in) { 0 }
      let(:quality) { 50 }

      it 'quality decreases twice as fast' do
        expect(item.quality).to eq 48
      end
    end

    context 'fully degraded item' do
      let(:sell_in) { 50 }
      let(:quality) { 0 }

      it 'can not have a quality of less than 0' do
        expect(item.quality).to eq 0
      end
    end

    context 'Sulfuras' do
      let(:name) { 'Sulfuras, Hand of Ragnaros' }
      let(:quality) { 50 }
      let(:sell_in) { 1 }
      let(:item) { Sulfuras.new(name, sell_in, quality) }

      it 'never degrades in quality' do
        expect(item.quality).to eq 50
      end

      it 'never needs to be sold' do
        expect(item.sell_in).to eq 1
      end
    end

    context 'Aged Brie' do
      let(:name) { 'Aged Brie' }
      let(:quality) { 0 }
      let(:sell_in) { 1 }
      let(:item) { AgedBrie.new(name, sell_in, quality) }

      it 'increases in quality as it gets older' do
        expect(item.quality).to eq 1
      end

      context 'after sell_in date' do
        let(:sell_in) { 0 }

        it 'increases in quality twice as fast' do
          expect(item.quality).to eq 2
        end
      end

      context 'max value' do
        let(:quality) { 50 }

        it 'can not have a quality greater than 50' do
          expect(item.quality).to eq 50
        end
      end
    end

    context 'Concert Tickets' do
      let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }
      let(:quality) { 0 }
      let(:item) { ConcertTicket.new(name, sell_in, quality) }

      context '10 days left to sell' do
        let(:sell_in) { 10 }

        it 'increase in quality by 2' do
          expect(item.quality).to eq 2
        end
      end

      context '5 days left to sell' do
        let(:sell_in) { 5 }

        it 'increase in quality by 3' do
          expect(item.quality).to eq 3
        end
      end

      context 'concert has already happened' do
        let(:sell_in) { 0 }

        it 'loses all its value' do
          expect(item.quality).to eq 0
        end
      end
    end
  end
end
