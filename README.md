# SpaceX API Demo with Flutter

A simple demonstration of using Flutter to read SpaceX API's
- Loads a list of launches
- Views details of the launch / payload

## Design Decisions
- The brief asked me to use the SpaceX API [V3](https://docs.spacexdata.com/) API, however it's deprecated and that page recommends to use it's successor, [V4](https://github.com/r-spacex/SpaceX-API/tree/master/docs#rspacex-api-docs). Therefore I adopted the latest.

## Further Enhancements
- Please see all embedded "// TODO:" in the code itself.

- Also we need to think about a caching strategy. Right now it loads the data on every page push / app re-open. This presents an opportunity to significantly improve UX by including a cache (and also to reduce costs on the backend calls if we are paying for the service, or even simply if we are hosting it). 

My initial idea would be to cache it on the device to persist across app closures within the same day. Must include a "pull down top refresh" on the page being cached of course, and also it should have a timeout when we decide the cached data is stale, so we can re-retrieve it; for example, if the cache is a day old.

Also another idea could be if we don't care about costs, is to ALWAYS present the cache to begin with, whilst refreshing it in the background, then immediately updating the UI with the latest once it comes back. This offers some improved UX, but there is also a risk that it hurts UX, for example, imagine scrolling the paginated list, you're on entry 25 or whatever, but a new entry is suddenly added at the top so you never saw it in that session.