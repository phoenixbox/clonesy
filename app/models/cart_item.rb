class CartItem
  attr_reader :product, :quantity

  def initialize(product, quantity)
    @product = product
    @quantity = quantity
  end

  def title
    product.title
  end

  def unit_price
    product.price
  end

  def total
    BigDecimal.new(quantity.to_s) * BigDecimal.new(unit_price.to_s)
  end
end
