---
title: An Introduction to the RUM Archive
date: 2022-12-14
description: A discussion of our motivation for the project, what kind of data the RUM Archive contains, how you can access it, its limitations, and some ideas for what it could be used for
layout: layouts/blog.njk
tags: blog
author: nic
toc: true
thumbnail: /assets/rum-archive-logo.svg
---

A few weeks ago at [performance.now()](https://perfnow.nl/), we were able to announce the initial availability of a new public dataset of RUM data - the [**RUM Archive**](https://rumarchive.com).

I'd like to take a few minutes to discuss our motivation for the project, what kind of data the RUM Archive contains, how you can access it, its limitations, and some ideas for what it could be used for.

## Why have a RUM Archive?

The RUM Archive is heavily inspired by projects like the [Wayback Machine](https://archive.org), the [HTTP Archive](https://httparchive.org), and the [Chrome UX Report (CrUX)](https://developer.chrome.com/docs/crux/).

Those projects have lead the way in being fantastic community-lead efforts that help share and preserve the history of the web and web performance.

We hope the RUM Archive will be a good compliment to those projects.  While the HTTP Archive focuses on metrics captured from synthetic crawls, and CrUX draws its RUM data from Chrome navigations across the globe, the RUM Archive offers another view of RUM data, and one that is across all browsers.

Our aim is to have RUM data available for researchers to analyze trends in market and performance analytics.  While the Akamai mPulse RUM dataset is the first made publicly available, we're hoping other individuals, websites or RUM providers may also consider sharing their data in the RUM Archive.  This would allow researchers to look at RUM data from several different points of view (e.g. a known website, or sampled from other RUM providers's customers).

## What kind of data is in the RUM Archive?

To start with, the RUM Archive primarily contains two types of data:

* **Page Loads**: Browser page load experiences
* **Resources**: Third party resource fetches

[Page Loads](/docs/tables/#page-loads) represent browser navigation experiences, whether from a traditional Multi-Page App (MPA) or Single-Page App (SPA). SPA navigations can be broken down into both Hard Navigations (the first navigation to the page) and Soft Navigations (in-page route changes).

[Resources](/docs/tables/#resources) (coming soon) will track individual asset (URL) fetches of third-party resources, that happened during a Page Load.  We will only be tracking URLs that are seeing on multiple sites, to ensure first-party assets are not tracked.

All data in the RUM Archive is is sampled and aggregated, which protects the privacy of individuals.

Have other ideas for what the RUM Archive could track?  [Let us know](https://github.com/rum-archive/rum-archive/issues)!

## How can I access it?

All of the RUM Archive data can be accessed by [Google BigQuery](https://cloud.google.com/bigquery).

[rumarchive.com](https://rumarchive.com) has a [guide](/docs/querying/) for how to access the public RUM Archive BigQuery database, but here are the basics:

1. Log-in or create a Google account
2. Navigate to the [Google Cloud Projects Console](https://console.cloud.google.com/start)
3. Use an existing, or create a new Google Cloud Project
4. Head over to the [Google BigQuery Console](https://console.cloud.google.com/bigquery)
5. Search for [RUM Archive Datasets](/datasets), e.g. `akamai-mpulse-rumarchive` and star it!

You're now ready to query the RUM Archive!

**Note**: BigQuery has costs for storage and querying. You'll want to review what's available in the free tier, and estimate how much querying the RUM Archive may cost. You can read our [tips](/docs/tips/#limiting-bigquery-costs) on how to reduce your BigQuery costs.  Akamai is paying the storage of the `akamai-mpulse-rumarchive` table, while researchers will pay for their own individual queries.

The [querying guide](/docs/querying/) goes over the various ways you can slice, and dice, and filter, and summarize the data, and we have some additional [sample queries](/docs/samples/).

For a simple example, lets say you want to see the relative popularity of HTTP Protocol for a particular day:

```sql
SELECT  PROTOCOL,
        SUM(BEACONS) as COUNT
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2022-09-01"
    AND COUNTRY = 'US'
GROUP BY PROTOCOL
ORDER BY COUNT(*) DESC
```

The output may be:

| protocol | count     |
|:---------|:----------|
| h2       | 101340387 |
| null     | 31832102  |
| http/1.1 | 5978377   |
| h3       | 134570    |
| h3-29    | 145       |
| http/1.0 | 277       |
| http/1   | 352       |
| unknown  | 88        |

You can see in the mPulse dataset (on 2022-09-01), H2 navigations dwarf the rest.

You can also see this data has some funky values like `h3-29` and `http/1.0` vs `http/1` -- you'll find that RUM data can be messy, as different browsers may report different values for the same thing.  One considering when querying the RUM Archive is figuring out if you'll need to normalize or cleanup any of the values.

A more complex example would be reviewing Page Load time by Country:

```sql
SELECT  COUNTRY,
        SUM(BEACONS) AS BEACONCOUNT,
        `akamai-mpulse-rumarchive.rumarchive.PERCENTILE_APPROX`(
          ARRAY_AGG(PLTHISTOGRAM),
          [0.50],
          100,
          false) as MEDIAN
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2022-09-01"
    AND BEACONTYPE = 'page view'
    AND USERAGENTFAMILY = 'Chrome'
GROUP BY COUNTRY
ORDER BY SUM(BEACONS) DESC
```

What are the results?  Check for yourself!

Of course these are just simple examples of how to process the RUM Archive data.  Read our [querying guide](/docs/querying/) and [sample queries](/docs/samples/) for more ideas.

## What is the RUM Archive useful for?

We see two primary use-cases for the RUM Archive data:

* **Marketing analytics**
  * Grouping by certain dimensions (for example, HTTP Protocol or Browser) allows you to calculate the relative weight (frequency) of those dimensions in the dataset on any particular day.
  * Over time, you could compare the relative weights to see market trends in popularity of each dimension.
  * NOTE: Since the RUM Archive data is sampled, absolute counts of `BEACONS` should only be used to compare data on the same `DATE` in a single dataset.  As the sampling rate may change from day-to-day, absolute count comparisons _between days_ should not be used, only _relative weights_.
* **Performance analytics**:
  * All of the common [performance timers and metrics](/docs/tables/#timers-and-metrics) you'd expect, like Page Load Time or the Core Web Vitals are tracked in several aggregated columns for each timer/metric, with `COUNT`, `HISTOGRAM`, `AVG` and `SUMLN` being provided.
  * These columns allow you to calculate:
    * Histograms from multiple rows by combining the `HISTOGRAM` columns using our [`COMBINE_HISTOGRAMS`](/docs/querying/#combined-histograms) function
    * Approximate Percentiles by combining the `HISTOGRAM` columns and running our [`PERCENTILE_APPROX`](/docs/querying/#approximate-percentiles) function
    * Weighted average by using the `AVG` and `COUNT` columns
    * Geometric means by using the `SUMLN` and `COUNT` columns

## Can anyone contribute data to the RUM Archive?

The short answer is **Yes!**

Initially the RUM Archive only has data from a single source: [Akamai mPulse RUM](/datasets/#akamai-mpulse-rum), which is measuring RUM across thousands of Akamai customers.

Our goal with the RUM Archive is for it to be a resource that goes beyond any single RUM vendor.  The [RUM Archive format](/docs/tables/) is open-source and the Akamai team has [documented](/docs/methodology/#exporting) how they approached aggregating and exporting [their own data](/datasets/#akamai-mpulse-rum) into BigQuery, and we hope this would allow others to take similar steps.

We would love to see other individuals, websites and RUM vendors [contribute](/contribute/) their own RUM data to the effort.

If anyone is curious how to do this, or would like help, please [open a Github issue](https://github.com/rum-archive/rum-archive/issues)!

## What are the downsides of the RUM Archive?

This data isn't perfect, and there are a lot of caveats to grasp when analyzing data from the RUM Archive:

* At this time, the RUM Archive only contains data from Akamai mPulse, so it is biased towards mPulse customers.
* All of the data in the RUM Archive is sampled (and the sampling rate isn't disclosed), so `BEACONS` counts should only be used for relative weighting for each day.
* Outliers are excluded (since the data is sampled, aggregated and a minimum count threshold is applied), which [will affect the accuracy](/docs/tips/#outliers-are-excluded) of queries.
* The datasets are partitioned by `DATE` so you'll generally want to limit queries to a single day to minimize BigQuery querying costs.

We'll probably find more limitations over time -- please let us know if you come across any other big gotchas.

## What's in the future for RUM Archive?

At this stage, we're hoping to get feedback that will help shape where we go with the project from here.

In particular, we'd like to know:

* If you're querying the data, please let us know your experience (a good way is to [open a Github issue](https://github.com/rum-archive/rum-archive/issues), [tweet](https://twitter.com/RUMArchive) or [toot](https://webperf.social/@rumarchive) at us)
* If you think the RUM Archive is missing a critical piece of data (i.e. you think another [dimension](/docs/tables/#dimensions) would be useful)
* If you're considering [contributing](/contribute/) your own RUM Archive data

We'd love to hear what you're doing with it!  Let us know!
