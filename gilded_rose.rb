class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item.update_quality()
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality
  QUALITY_LIMIT = 50

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def update_quality
    if !expired?
      @sell_in -= 1
      @quality -= 1 if !fully_degraded?
    else
      @quality -= 2 if !fully_degraded?
    end
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  private

  def expired?
    @sell_in == 0
  end

  def fully_degraded?
    @quality == 0
  end

  def max_quality?
    @quality == QUALITY_LIMIT
  end
end

class AgedBrie < Item
  def update_quality
    if expired?
      @quality += 2 if !max_quality?
    else
      @sell_in -= 1
      @quality += 1 if !max_quality?
    end
  end
end

class Sulfuras < Item
  def update_quality
    # do nothing - doesn't lose value or need to be sold
  end
end

class ConcertTicket < Item
  def update_quality
    @sell_in -= 1 if !expired?

    if @sell_in.zero?
      @quality = 0
    elsif @sell_in < 6
      @quality += 3
    elsif @sell_in < 10
      @quality += 2
    end
  end
end
