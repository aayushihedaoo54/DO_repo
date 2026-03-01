class concurrencyService
    def self.acquire(client_id)
        key = "client:#{client_id}:running_count"
        limit = Client.find_by(client_id: client_id)&.concurrency_limit || 5

        current = Redis.current.incr(key)

        if current > limit
            Redis.current.descr(key)
            return false
        end
        true
    end

    def self.release(client_id)
        Redis.current.decr("client:#{client_id}:running_count")
    end
end