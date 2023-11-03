---
title: Datasets
layout: layouts/page.njk
---

## Contributing

Want to contribute your own data to the RUM Archive?  See the [contributing guide](/contribute).

## Akamai mPulse RUM

[Akamai mPulse](https://www.akamai.com/products/mpulse-real-user-monitoring) is a RUM product that maps user behavior
to business performance as it's happening. With mPulse you can collect detailed business and performance data directly
from your users' browser in real time, and then drill down for a closer look at the performance of all your resources
across all of your page views to identify the root cause of latencies and lost revenue.

Technical Details:

* License: [CC BY SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)
* Collected via: [boomerang.js](https://github.com/akamai/boomerang)
* Aggregation cadence: **Daily**
* Release cadence: **Monthly**
* Page Loads: **Yes**
  * Sampling: A random percentage of normalized data from mPulse's top 100 customers
  * Size: Approximately 200 million page loads aggregated per day
* Resources: **Yes**
  * Sampling: Top 500+ resource URLs that were fetched by multiple customers
  * Size: Approximately 160m resource fetches aggregated per day
* Google BigQuery project: `akamai-mpulse-rumarchive`
  * Dataset: `rumarchive`
  * Page Loads table: `rumarchive_page_loads`
    * Available first day of the month data (single day granularity):
      * `2021-10-01`, `2021-11-01`, `2021-12-01`
      * `2022-01-01`, `2022-02-01`, `2022-03-01`, `2022-04-01`, `2022-05-01`, `2022-06-01`, `2022-07-01`, `2022-08-01`
    * Available daily data:
      * `2022-09-01` (onward, daily), through `2023-10-31`
  * Resources table: `rumarchive_resources`
    * Available dates: `2023-10-15` (onward, daily) through `2023-10-31`
* Known issues:
  * Resources table's `protocol` column is not set
