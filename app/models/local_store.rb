class LocalStore
  def self.increase_popularity(thing)
    key = key(thing.class, :popular)

    REDIS.pipelined do
      ensure_ttl(key)

      if REDIS.zscore(key, thing.id)
        REDIS.zincrby(key, 1, thing.id)
      else
        REDIS.add(key, thing.id)
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
  def self.key(thing, qualifier)
    "#{qualifier}_#{thing.to_s.downcase.pluralize}"
  end

  def self.ensure_ttl(key)
    REDIS.expire(key, 86400) if REDIS.ttl(key) == -1
  end
end
