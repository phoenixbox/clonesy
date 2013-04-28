class LocalStore
  def self.increase_popularity(thing)
    key = key(thing.class, :popular)

    REDIS.pipelined do
      ensure_ttl(key)

      REDIS.zscore(key, thing.id) ? REDIS.zincrby(key, 1, thing.id) : REDIS.add(key, id)
    end
  end

  def self.popular(thing)
    key = key(thing, :popular)
    case thing.to_s
    when 'Product' then REDIS.zrevrange(key, 0, 3)
    when 'Store' then set = REDIS.zrevrange(key, 0, 0); set.present? ? set.first : nil
    else nil; end
  end

private
  def self.key(thing, qualifier)
    "#{qualifier}_#{thing.to_s.downcase.pluralize}"
  end

  def self.ensure_ttl(key)
    REDIS.expire(86400) if REDIS.ttl(key) == -1
  end
end
