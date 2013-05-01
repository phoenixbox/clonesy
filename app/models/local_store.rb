class LocalStore

  def self.increase_popularity(model_class_name, model_id, user)

    return if user_has_already_visited?(model_class_name, model_id, user)

    add_visitor(model_class_name, model_id, user)

    update_popularity(model_class_name, model_id)

  end 

  def self.popular_products
    key = key('product')
    REDIS.zrevrange(key, 0, 3)
  end
 
  def self.popular_store
    key = key('store')
    REDIS.zrevrange(key, 0, 0).first
  end

private

  def self.user_has_already_visited?(model_class_name, model_id, user)  
    REDIS.sismember("#{model_class_name}:#{model_id}", user)
  end

  def self.add_visitor(model_class_name, model_id, user)
    key = key_for_model(model_class_name, model_id)
    set(key,user)
  end

  def self.update_popularity(model_class_name, model_id)
    key = key(model_class_name)
 
    REDIS.pipelined do
      ensure_ttl(key)
      REDIS.zincrby(key, 1, model_id)
    end
  end

  def self.set(key,user)
    REDIS.sadd(key, user)
    ensure_ttl(key)
  end

  def self.key(model_class_name)
    "popular_#{model_class_name.pluralize}"
  end
 
  def self.ensure_ttl(key)
    REDIS.expire(key, 86400) if REDIS.ttl(key) == -1
  end

  def self.key_for_model(model_class_name, model_id)
    "#{model_class_name}:#{model_id}"
  end
end


