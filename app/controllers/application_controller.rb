class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_cart, :current_store, :flag, :store_theme,
                :store_products_path, :edit_store_product_path

  before_filter :locale

  def store_theme
    @store_theme ||= current_store ? current_store.theme : 'default'
  end

  def require_admin
    if current_store.nil? || !current_store.is_admin?(current_user)
      not_authenticated
    end
  end

  def require_admin_or_stocker
    @role = current_store.admin_or_stocker?(current_user)
    if current_store.nil? || !@role
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
    if current_user && current_user.uber?
      @store ||= Store.where(path: params[:store_path]).first
    else
      @store ||= Store.online.where(path: params[:store_path]).first
    end
  end

  def locale
    I18n.locale = session[:i18n] || I18n.default_locale || :en
  end

  def store_products_path(role, store)
    if role == :admin
      store_admin_products_path(store)
    elsif role == :stocker
      store_stock_products_path(store)
    end
  end

  def edit_store_product_path(role, store, product)
    if role == :admin
      edit_store_admin_product_path(store, product)
    elsif role == :stocker
      store_stock_edit_product_path(store, product)
    end
  end

  def flag
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
