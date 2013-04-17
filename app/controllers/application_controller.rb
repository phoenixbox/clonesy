class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_cart, :current_store, :get_flag
  before_filter :get_locale

  def require_admin
    if current_store.nil? || !(current_store.is_admin?(current_user) || current_user.uber?)
      not_authenticated
    end
  end

  def require_admin_or_stocker
    if current_store.nil? || !current_store.is_admin_or_stocker?(current_user)
      not_authenticated
    end
  end

  def require_uber
    not_authenticated unless current_user && current_user.uber?
  end

  def not_authenticated
    redirect_to login_path,
                alert: "You are not authorized to visit that page :("
  end

  def require_current_store
    if !current_store
      raise ActionController::RoutingError.new('Store is not online')
    end
  end

  def current_cart
    session[:cart] ||= {}
    @cart ||= SessionCart.new(session[:cart], current_store)
  end

  def current_store
    @store ||= Store.online.where(path: params[:store_path]).first
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
