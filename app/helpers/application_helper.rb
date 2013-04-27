module ApplicationHelper
  # TODO: Completely remove this horrible hack. kkthx
  def gen_image_url(store, id)
    if store == 'bike'
      "https://s3.amazonaws.com/dose/#{store}_#{id}.jpg"
    elsif store == 'bracelet'
      number = id - 20
      "https://s3.amazonaws.com/dose/#{store}_#{number}.jpg"
    end
  end
end
