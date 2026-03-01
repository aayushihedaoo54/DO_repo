# DESIGN.md

## Distributed Task Orchestrator -- Architectural Design

------------------------------------------------------------------------

# 1️⃣ Scaling to 100k Jobs/Hour

Target throughput: \~100,000 jobs/hour (\~28 jobs/second sustained).

The system is designed to handle burst traffic while maintaining
fairness, consistency, and quota guarantees.

------------------------------------------------------------------------

## Mitigating Redis Contention

Redis is used for: - Concurrency counters - Heartbeats - Lightweight
coordination

### Strategy

1.  Use isolated per-client keys (avoid hot global keys)
2.  Only use O(1) operations like INCR/DECR
3.  Avoid heavy distributed locks
4.  Use connection pooling (Sidekiq-managed)
5.  Deploy Redis Cluster in production

Redis is treated as a coordination/cache layer --- not the source of
truth.

------------------------------------------------------------------------

## Sharding Strategy

Shard by client_id using hash partitioning:

Shard = hash(client_id) % total_shards

Each shard maintains: - Client job queue - Client concurrency counters

Prevents hot key concentration and client starvation.

------------------------------------------------------------------------

## Scheduler vs Executor Separation

Architecture:

Client → API → Database ↓ Scheduler ↓ Sidekiq ↓ Executors

Benefits: - Independent scaling - Fault isolation - Better
observability - Backpressure control

------------------------------------------------------------------------

# 2️⃣ Failure Modes

## Redis FLUSHALL

If Redis loses all keys:

-   Concurrency counters lost
-   Heartbeats lost

Recovery: - DB remains source of truth - Scheduler scans running jobs -
Jobs without heartbeat marked stalled - Counters rebuilt lazily

System remains consistent because job state lives in MySQL.

------------------------------------------------------------------------

## Split-Brain (Two Workers Stall Same Job)

Use atomic DB transition:

UPDATE jobs SET status = 'stalled' WHERE id = ? AND status = 'running';

If affected rows = 0 → transition already handled.

Prevents duplicate state transitions.

------------------------------------------------------------------------

## Frozen Worker (Long GC Pause)

If no heartbeat for 60 seconds: → Job marked stalled

System provides At-Least-Once execution. Idempotent job logic ensures
safe retries.

------------------------------------------------------------------------

# 3️⃣ Retry Semantics

Exponential backoff:

delay = 2\^retry_count seconds

Guarantees: - Retries respect concurrency quota - Max retry cap
enforced - No bypass of quota

Processing Model: At-Least-Once with idempotency.

------------------------------------------------------------------------

# 4️⃣ Abuse Protection

If client submits 1M jobs in 10 seconds:

### API Layer Protection

-   Rate limiting per client
-   Token bucket (Redis)
-   Return HTTP 429 when exceeded

### Scheduler Fairness

-   Weighted Fair Queuing
-   Round-robin across client_ids

### Backpressure

-   Reject jobs when queue depth exceeds threshold
-   Return "System Busy"

------------------------------------------------------------------------

# 5️⃣ Database Protection

Use indexed queries and SKIP LOCKED:

SELECT \* FROM jobs WHERE status = 'queued' FOR UPDATE SKIP LOCKED LIMIT
100;

Prevents scheduler collisions.

------------------------------------------------------------------------

# 6️⃣ Observability

Health endpoint returns 503 if: - DB unavailable - Redis unavailable -
Sidekiq latency \> 15 seconds

Supports Kubernetes liveness and alerting.

------------------------------------------------------------------------

# 7️⃣ Consistency Model

Source of truth: MySQL

Redis: reconstructable coordination layer

System prioritizes: - Strong state consistency - Global quota
enforcement - Fair scheduling - Graceful failure recovery - Horizontal
scalability

------------------------------------------------------------------------

# Final Design Philosophy

The orchestrator separates: - State (MySQL) - Coordination (Redis) -
Execution (Sidekiq) - Scheduling (Dedicated worker)

This ensures scalability, resilience, and operational clarity.
