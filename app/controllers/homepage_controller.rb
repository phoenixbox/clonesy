class HomepageController < ApplicationController
  def show
    @highlights = Highlights.from_database
  end
end
