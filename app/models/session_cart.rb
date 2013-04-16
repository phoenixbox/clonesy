class SessionCart

  def initialize(db, current_store)
    @current_store = current_store

    @db = db
    @db[@current_store.id] ||= Hash.new(0)

    @cart = Cart.new(@db[@current_store.id])
  end

  def total
    @cart.total
  end

  def count
    @cart.count
  end

  def empty?
    @cart.empty?
  end

  def each(&block)
    @cart.items.each(&block)
  end

  def remove_item(product_id)
    update_cart(@cart.remove_item(product_id))
  end

  def update(cart_data)
    update_cart(@cart.update(cart_data))
  end

  def destroy
    update_cart(@cart.destroy)
  end

private

  def update_cart(cart_data)
    @db[@current_store.id] = cart_data
  end

end
