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
* Release cadence: **Daily** (automated, by 12pm GMT for previous day)
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
      * `2022-09-01` (onward, daily)
  * Resources table: `rumarchive_resources`
    * Available dates: `2023-10-15` (onward, daily)
* Additional information:
  * User Agent parsing is done via the [`ua-parser`](https://github.com/ua-parser/) library, using the [`regexes.yaml`](https://github.com/ua-parser/uap-core/blob/master/regexes.yaml) rules
* Known issues:
  * Resources table's `protocol` column is not set
* Changelog: See the [release notes](/docs/release-notes/) for breaking changes

## Akamai Employee Individual Datasets

A few Akamai employees with personal websites have opted in to publishing their RUM data to the RUM Archive.

These websites are aggregated independently, and are individually identifiable via the `SITE` column.  Their data is published to the `rumarchive_page_loads_individual` table (instead of the `rumarchive_page_loads` table the regular mPulse Dataset is published to).

Technical Details:

* License: [CC BY SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)
* Collected via: [boomerang.js](https://github.com/akamai/boomerang) via mPulse
* Aggregation cadence: **Daily**
* Release cadence: **Daily** (automated, by 2pm GMT for previous day)
* Websites:
  * [sarna.net](https://www.sarna.net) - Nic Jansma
  * [scalemates.com](https://scalemates.com) - Tim Vereecke
  * [virtualglobetrotting.com](https://virtualglobetrotting.com) - Nic Jansma
* Page Loads: **Yes**
  * Sampling: No sampling
  * Size: Approximately 300,000 page loads aggregated per day
* Resources: **No**
* Google BigQuery project: `akamai-mpulse-rumarchive`
  * Dataset: `rumarchive`
  * Page Loads table: `rumarchive_page_loads_individual`
    * Available daily data:
      * `2024-06-01` (onward, daily)
