class AdminOrder
  attr_reader :orders,
              :status_count,
              :active_tab

  def initialize(orders, status_count, active_tab)
    @orders = orders
    @status_count = status_count
    @active_tab = active_tab
  end

  def self.from_database(current_store, status)
    orders = current_store.orders_by_status(status)
    empty_statuses = {'pending' => 0,
                      'cancelled' => 0,
                      'paid' => 0,
                      'shipped' => 0,
                      'returned' => 0}
    # TODO: Refactor this to new SQL query so we don't hit DB for all orders for store
    status_count = current_store.orders.inject(empty_statuses) { |memo, order| memo[order.status] += 1; memo }
    active_tab = status
    new(orders, status_count, active_tab)
  end
end

