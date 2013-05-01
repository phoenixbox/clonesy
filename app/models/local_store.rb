class LocalStore
  def self.increase_popularity(thing, user)

    if unique_user?(thing, user)

      key = key(thing.class, :popular)

      REDIS.pipelined do
        check_expiration(key)

        if REDIS.zscore(key, thing.id)
          REDIS.zincrby(key, 1, thing.id)
        else
          REDIS.add(key, thing.id)
        end
      end
    end
  end

  def self.popular(thing)
    key = key(thing, :popular)
    if thing.to_s == 'Product'
      REDIS.zrevrange(key, 0, 3)
    elsif thing.to_s == 'Store'
      set = REDIS.zrevrange(key, 0, 0)
      set.present? ? set.first : nil
    end
  end

private

#key of the store/product, value is the ip address. 

  def unique_user?(thing, user)  
    if REDIS.sismember("store_#{thing.id}", user) == 1 || REDIS.sismember("product_#{thing.id}", user) == 1
      false
    else
      REDIS.sadd store_visitors(user)
      true
    end
  end

  def store_visitors(thing)
    REDIS.key thing || REDIS.add thing
  end

  def self.key(thing, qualifier)
    "#{qualifier}_#{thing.to_s.downcase.pluralize}"
  end

  def self.check_expiration(key)
    REDIS.expire(key, 86400) if REDIS.ttl(key) == -1
  end
end
