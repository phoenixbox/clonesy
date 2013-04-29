class Highlights
  def self.from_database
    new.tap do |highlights|
      highlights.popular_products
      highlights.recent_products
      highlights.popular_store
      highlights.recent_store
    end
  end

  def popular_products
    @popular_products ||= Product.popular
  end

  def recent_products
    @recent_products ||= Product.recent
  end

  def popular_store
    @popular_store ||= Store.popular
  end

  def recent_store
    @recent_store ||= Store.recent
  end
end
