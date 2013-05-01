class Highlights
  attr_reader :popular_products,
              :recent_products,
              :popular_store,
              :recent_store

  def initialize(pp, rp, ps, rs)
    @popular_products = pp
    @recent_products  = rp
    @popular_store    = ps
    @recent_store     = rs
  end

  def self.from_database
    pp = Product.popular
    rp = Product.recent
    ps = Store.popular
    rs = Store.recent

    new(pp, rp, ps, rs)
  end
end
