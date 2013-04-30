class Cart
  attr_accessor :cart_hash

  def initialize(cart_hash)
    @cart_hash = cart_hash
  end

  def each(&block)
    items.each(&block)
  end

  def items
    products = Product.find(cart_hash.keys).index_by(&:id)

    cart_hash.map do |id, quantity|
      CartItem.new(products[id.to_i], quantity)
    end
  end

  def total
    items.map { |item| item.total }.inject(&:+)
  end

  def remove_item(product_id)
    if product_id.present?
      cart_hash.delete(product_id)
    end
    cart_hash
  end

  def update(carts_param)
    if id = carts_param[:product_id]
      quantity = carts_param[:quantity]
      unless quantity.to_i < 0
        cart_hash[id] = quantity || (cart_hash[id].to_i + 1).to_s
      end
    end
    cart_hash
  end

  def destroy
    cart_hash.clear
  end

  def count
    cart_hash.present? ? "(#{calculate_count})" : nil
  end

  def empty?
    items.empty?
  end

private
  def calculate_count
    cart_hash.values.map(&:to_i).reduce(&:+)
  end
end
