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
    * [Schema version](/docs/release-notes): 1.5
  * Resources table: `rumarchive_resources`
    * Available dates: `2023-10-15` (onward, daily)
    * [Schema version](/docs/release-notes): 1.5
* Additional information:
  * Each website is capped at the same number of page loads (the volume of the 100th ranked website), so larger websites do not dominate the dataset sampling
  * User Agent parsing is done via the [`ua-parser`](https://github.com/ua-parser/) library, using the [`regexes.yaml`](https://github.com/ua-parser/uap-core/blob/master/regexes.yaml) rules
  * Page loads from known bot and automation User Agents are excluded
  * `SOURCE` is set to `mpulse` and `SITE` is set to `(multiple)`
* Known issues:
  * Resources table's `protocol` column is not set
  * `INP*` data was not available from 2024-02-14 through 2026-03-09
  * The dimensions and timers added to the format in [version 1.6](/docs/release-notes) (`USERAGENTENGINE`, `USERAGENTENGINEVERSION`, `INDUSTRY`, `TRANSFERSIZE*`, `INTERIMRESPONSE*`, `LCPLOADDELAY*`, `LCPLOADTIME*`, `LCPRENDERDELAY*`, `INPINPUTDELAY*`, `INPPROCESSINGDURATION*` and `INPPRESENTATIONDELAY*`) are not available in the mPulse datasets
* Changelog: See the [release notes](/docs/release-notes/) for breaking changes

## Akamai Employee Individual Websites Datasets

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
    * [Schema version](/docs/release-notes): 1.5

## Cloudflare BEACON Dataset

The **Cloudflare BEACON** (Browser Experience Across Cloudflare's Observed Network) Dataset is an aggregation
of Real User Monitoring data collected by [Cloudflare RUM](https://www.cloudflare.com/web-analytics/),
Cloudflare's privacy-first RUM product.

Technical Details:

* License: [CC BY SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)
* Collected via: [Cloudflare RUM](https://developers.cloudflare.com/web-analytics/)
* Aggregation cadence: **Daily**
* Release cadence: **Daily** (automated, for previous day)
* Page Loads: **Yes**
  * Sampling: A random percentage of normalized data from Cloudflare's top 10,000 websites (by daily page load volume)
  * Size: Approximately 4.5 billion page loads aggregated per day
* Resources: **No**
* Google BigQuery project: `cf-open-web-performance`
  * Dataset: `rumarchive`
  * Page Loads table: `rumarchive_page_loads`
    * Available daily data:
      * `2026-09-20` (onward, daily)
    * [Schema version](/docs/release-notes): 1.6
* Additional information:
  * Each website is capped at the same number of page loads (the volume of the 10,000th ranked website), so larger websites do not dominate the dataset sampling
  * Page loads from known bot and automation User Agents are excluded
  * `SOURCE` is set to `cloudflare` and `SITE` is set to `(multiple)`
  * User Agent, Operating System and Browser Engine names and versions are determined by Cloudflare's RUM pipeline (not the [`ua-parser`](https://github.com/ua-parser/) library used by the mPulse datasets), so values may differ slightly from the other datasets
* Known issues:
  * Page Loads:
    * The following dimensions are always empty: `DEVICEMODEL`, `VISIBILITYSTATE` and `IPVERSION`
    * The following timers and metrics are always empty: `RTT`, `RAGECLICKS`, `FID`, `TBT`, `TTI` and `UNO`
    * `BEACONTYPE` is limited to `page view`, `bfcache` and `spa` (not `spa hard`) as Cloudflare RUM does not measure SPA Hard Navigations

