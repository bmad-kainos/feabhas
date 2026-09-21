# Summary

This change adds cursor-based pagination to the orders list endpoint, replacing the previous offset-based approach. It keeps responses fast and stable for large result sets and lets clients page through results reliably when data changes between requests.

## List of Changes

- **backend**: updated the orders list handler to accept a `cursor` query parameter and return a `nextCursor` in the response
- **api**: updated the OpenAPI spec to document the new pagination parameters and response fields
- **testing**: added tests covering the first page, subsequent pages, empty results, and an invalid cursor
- **documentation**: updated the API reference with pagination usage and examples
- **frontend**: updated the results list to request the next page using `nextCursor`
- **logs**: added a log line recording page size and cursor for troubleshooting
