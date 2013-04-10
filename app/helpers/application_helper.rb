module ApplicationHelper
  def gen_image_url(id)
    "http://robohash.org/#{id}"
  end
end
