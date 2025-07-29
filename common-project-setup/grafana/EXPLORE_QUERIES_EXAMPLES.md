# Grafana Explore - PostgreSQL Logs Query Examples

This guide provides example queries for exploring PostgreSQL logs in Grafana's Explore menu using Loki as the data source.

## Basic Log Queries

### 1. View All PostgreSQL Logs
```logql
{container="postgres"}
```
Shows all logs from the PostgreSQL container.

### 2. Recent Logs (Last 5 minutes)
```logql
{container="postgres"}[5m]
```
Displays PostgreSQL logs from the last 5 minutes.

### 3. Filter by Log Level
```logql
{container="postgres"} |= "ERROR"
```
Shows only ERROR level logs.

```logql
{container="postgres"} |= "WARNING"
```
Shows only WARNING level logs.

## SQL Statement Analysis

### 4. All SQL Statements
```logql
{container="postgres"} |= "statement:"
```
Filters logs containing SQL statements.

### 5. SELECT Queries Only
```logql
{container="postgres"} |= "statement:" |= "SELECT"
```
Shows only SELECT statement logs.

### 6. INSERT/UPDATE/DELETE Operations
```logql
{container="postgres"} |= "statement:" |~ "(INSERT|UPDATE|DELETE)"
```
Displays data modification operations.

### 7. Queries on Specific Tables
```logql
{container="postgres"} |= "statement:" |= "FROM users"
```
Shows queries involving the 'users' table.

## Performance Monitoring

### 8. Query Duration Analysis
```logql
{container="postgres"} |= "duration:"
```
Shows logs with query execution duration.

### 9. Slow Queries (>100ms)
```logql
{container="postgres"} |= "duration:" | regexp "duration: (?P<duration>[0-9.]+) ms" | duration > 100
```
Filters queries taking longer than 100 milliseconds.

### 10. Very Slow Queries (>1000ms)
```logql
{container="postgres"} |= "duration:" | regexp "duration: (?P<duration>[0-9.]+) ms" | duration > 1000
```
Shows queries taking longer than 1 second.

## Connection and Authentication

### 11. Connection Events
```logql
{container="postgres"} |= "connection"
```
Displays connection-related logs.

### 12. Authentication Failures
```logql
{container="postgres"} |= "authentication failed"
```
Shows failed authentication attempts.

### 13. New Connections
```logql
{container="postgres"} |= "connection received"
```
Displays new connection events.

## Database-Specific Queries

### 14. Logs from Specific Database
```logql
{container="postgres"} |= "myapp@"
```
Filters logs from the 'myapp' database.

### 15. User-Specific Activity
```logql
{container="postgres"} |= "user=postgres"
```
Shows activity from the 'postgres' user.

## Advanced Filtering

### 16. Exclude Routine Logs
```logql
{container="postgres"} != "checkpoint" != "autovacuum"
```
Excludes routine maintenance logs.

### 17. Multiple Conditions
```logql
{container="postgres"} |= "ERROR" |= "relation"
```
Shows ERROR logs related to database relations.

### 18. Time-Based Filtering with Regex
```logql
{container="postgres"} | regexp "(?P<timestamp>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3} UTC)"
```
Extracts timestamp information from logs.

## Metrics and Aggregations

### 19. Log Rate Over Time
```logql
rate({container="postgres"}[5m])
```
Shows the rate of log entries per second over 5-minute windows.

### 20. Count of Errors
```logql
sum(count_over_time({container="postgres"} |= "ERROR" [5m]))
```
Counts ERROR logs over 5-minute intervals.

### 21. SQL Statement Rate
```logql
sum(rate({container="postgres"} |= "statement:" [5m]))
```
Shows the rate of SQL statements per second.

## Troubleshooting Queries

### 22. Lock-Related Issues
```logql
{container="postgres"} |~ "(deadlock|lock)"
```
Finds logs related to database locks and deadlocks.

### 23. Memory Issues
```logql
{container="postgres"} |~ "(memory|out of memory)"
```
Shows memory-related error logs.

### 24. Disk Space Issues
```logql
{container="postgres"} |~ "(disk|space)"
```
Displays disk space related logs.

## Tips for Using Explore

1. **Time Range**: Use the time picker to focus on specific time periods
2. **Live Tail**: Enable live tailing to see logs in real-time
3. **Log Context**: Click on log lines to see surrounding context
4. **Export**: Use the "Split" feature to compare different queries
5. **Regex Testing**: Use online regex testers to validate complex patterns

## Common LogQL Operators

- `|=`: Contains (case-sensitive)
- `!=`: Does not contain
- `|~`: Regex match
- `!~`: Regex does not match
- `|`: Pipe for processing
- `regexp`: Extract fields with named groups
- `json`: Parse JSON logs
- `logfmt`: Parse logfmt logs

## Performance Tips

1. Use specific time ranges to limit data
2. Add container labels early in the query
3. Use `|=` before `|~` for better performance
4. Limit results with `| limit 100` when exploring
5. Use metrics queries for aggregations over large time ranges