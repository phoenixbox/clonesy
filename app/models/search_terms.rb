class SearchTerms
  def self.list
    Store.online.map { |store| store.products }.flatten.map { |product| product.title }
  end

  def self.match_by_title(title)
    products = Store.online.map { |store| store.products }.flatten
    products.select { |product| product.title.downcase.include? title.downcase }.first
  end
end