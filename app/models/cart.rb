class Cart
  def initialize(cart_data)
    @cart_data = cart_data
  end

  def items
    @cart_data.map do |id, quantity|
      CartItem.new(Product.find(id), quantity)
    end
  end

  def total
    items.map { |item| item.total }.inject(&:+)
  end

  def remove_item(product_id)
    if product_id.present?
      @cart_data.delete(product_id)
    end
    @cart_data
  end

  def update(carts_param)
    if id = carts_param[:product_id]
      quantity = carts_param[:quantity]
      @cart_data[id] = quantity || (@cart_data[id].to_i + 1).to_s
    end
    @cart_data
  end

  def destroy
    @cart_data = {}
  end

  def count
    @cart_data.present? ? "(#{calculate_count})" : nil
  end

  def empty?
    items.empty?
  end

private
  def calculate_count
    @cart_data.values.map(&:to_i).reduce(&:+)
  end
end
