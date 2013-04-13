class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_cart, :current_store, :get_flag
  before_filter :get_locale

  def require_admin
    if current_store.nil? || !current_store.is_admin?(current_user)
      not_authenticated
    end
  end

  def require_uber
    not_authenticated unless current_user && current_user.uber?
  end

  def not_authenticated
    redirect_to login_path, :alert => "First login to access this page."
  end

  def find_or_create_cart
    session[:cart] ||= Hash.new(0)
  end

  def current_cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_store
    @store ||= Store.where(path: params[:store_path]).first
  end

  def get_locale
    I18n.locale = session[:i18n] || I18n.default_locale || :en
  end

  def get_flag
    case session[:i18n]
    when 'fr' then 'fr'
    when 'cs' then 'cs'
    when 'ca' then 'ca'
    else 'us'
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
