class Highlights
  def self.from_database
    new.tap do |highlights|
      highlights.featured_products
      highlights.recent_products
      highlights.featured_store
      highlights.recent_store
    end
  end

  def featured_products
    @featured_products ||= Product.featured
  end

  def recent_products
    @recent_products ||= Product.recent
  end

  def featured_store
    @featured_store ||= Store.featured
  end

  def recent_store
    @recent_store ||= Store.recent
  end
end
