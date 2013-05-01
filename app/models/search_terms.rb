class SearchTerms
  def self.list
    Product.all.collect {|product| product.title}
  end

  def self.match_by_title(title)
    Product.where('title iLIKE ?', "%#{title}%").first
  end
end