# SFMovieLocations

This app shows a list of movie locations in San Francisco, as gleaned from the open API at sfdata.gov.

## Notes on future work

Some notes on things which could be done to improve the application:

* "Normalize" the data model into Movies and Locations; change the UI so that all locations for a movie are shown at once.
* Cache the data using Core Data or some other client-side data layer.
* If the application grows more than 2 view controllers, consider moving the segue logic into a separate "routing" layer.
