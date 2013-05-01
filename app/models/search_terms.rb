class SearchTerms
  def self.list
    Product.all.collect {|product| product.title}
  end
end