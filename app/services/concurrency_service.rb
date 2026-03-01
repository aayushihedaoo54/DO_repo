# class ConcurrencyService
#     def self.acquire(client_id)
#         key = "client:#{client_id}:running_count"
#         limit = Client.find_by(client_id: client_id)&.concurrency_limit || 5

#         current = Redis.current.incr(key)

#         if current > limit
#             Redis.current.descr(key)
#             return false
#         end
#         true
#     end

#     def self.release(client_id)
#         Redis.current.decr("client:#{client_id}:running_count")
#     end
# end

class ConcurrencyService
  def self.redis
    @redis ||= Redis.new(url: "redis://127.0.0.1:6379/0")
  end

  def self.acquire(client_id)
    key = "client:#{client_id}:running_count"
    limit = Client.find_by(client_id: client_id)&.concurrency_limit || 5

    current = redis.incr(key)

    if current > limit
      redis.decr(key)
      return false
    end

    true
  end

  def self.release(client_id)
    redis.decr("client:#{client_id}:running_count")
  end
end