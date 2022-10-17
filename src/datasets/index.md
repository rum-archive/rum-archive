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

* Data License: <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC BY SA 4.0</a>
* Data aggregation cadence: **Daily**
* Data release cadence: **Monthly**
* Page Loads: **Yes**
    * Sampling: A random percentage of normalized data from mPulse's top 100 customers
    * Size: Approximately 200 million page loads aggregated per day
* Resources: **Yes**
    * Sampling: Top 2,000 resource URLs that were fetched by multiple customers
* Google BigQuery project: `akamai-mpulse-rumarchive`
    * Dataset: `rumarchive`
    * Page Loads table: `rumarchive_pageloads`
    * Resources table: `rumarchive_resources`
