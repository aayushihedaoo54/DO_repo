class HealthController < ApplicationController
  def detailed
    db_ok = ActiveRecord::Base.connection.active?

    redis = Redis.new(url: "redis://127.0.0.1:6379/0")
    redis_ok = redis.ping == "PONG"

    queue_latency = Sidekiq::Queue.new.latency rescue 0

    status_code = (!db_ok || !redis_ok || queue_latency > 15) ? 503 : 200

    render json: {
      database: db_ok,
      redis: redis_ok,
      queue_latency: queue_latency
    }, status: status_code
  end
end