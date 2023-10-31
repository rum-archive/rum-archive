---
title: RUM Archive One Year Anniversary
date: 2023-11-01 00:00:00
description: The RUM Archive was announced one year ago!  We're announcing a new feature called RUM Insights, as well as a preview of Third-Party Resource data.
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /blog/2023-11-01-rum-archive-one-year-anniversary.svg
---

The RUM Archive was released about a year ago during the [performance.now() 2022](https://perfnow.nl/) conference in Amsterdam!  Let's review what's happened with the project over the last year, and then we can share some exciting new features we're adding.

First, a few notes on our October data release.

## Latest mPulse RUM Data Loaded

We've completed an export of mPulse daily RUM data into the BigQuery [`akamai-mpulse-rumarchive`](/datasets/#akamai-mpulse-rum) project up through 2023-10-31.

This brings the RUM Archive's [mPulse dataset](/datasets/#akamai-mpulse-rum) to a running total of 425 straight days of data available since 2022-09-01.  (There is also first-of-month data going back to 2021-10-01).

We plan to continue this daily export of the mPulse RUM data for the forseeable future.  Right now, we're updating the BigQuery tables roughly on a monthly cadence, where we release the previous month's data by the first few days of the next month.  We plan on automating this process further so that we can upload data on a daily cadence.

## RUM Archive Data In the Wild

One of our stated goals of the project is to make RUM data freely available so web performance nerds can use it for their own research.

We've received a lot of support for the project since its release, and look forward to making it better based on the community's feedback.

We know of a few places where RUM Archive data has been used, let's take a look!

[Annie Sullivan](https://twitter.com/anniesullie) was able to query the RUM Archive's data on Rage Clicks as part of research the Chrome Speed Metrics team was doing on rage clicks:

https://twitter.com/anniesullie/status/1621521096788049922

Our very own [Tim Vereecke](https://twitter.com/TimVereecke) has used the RUM Archive data in his presentation titled _Noise Cancelling RUM_ that's been given at [P99](https://www.p99conf.io/agenda/), [We Love Speed](https://www.welovespeed.com/en/2023/speakers/#tim_vereecke) and soon at [perf.now() 2023](https://perfnow.nl/speakers):

https://twitter.com/TimVereecke/status/1598261516897202176

[Henri Helvetica](https://twitter.com/HenriHelvetica) also interviewed [Nic Jansma](https://twitter.com/nicj) for an exploration on how to use and query the RUM Archive:

https://www.youtube.com/watch?v=zH7XmsWmRCo

Are **you** using the RUM Archive data in an interesting way?  [Let us know](https://twitter.com/RUMArchive)!

## RUM Insights

Until now, the [rumarchive.com](https://rumarchive.com) domain has been mostly a documentation website, with instructions on how you can query the BigQuery RUM data and a few example SQL queries.

We're now announcing a section for the site called [_RUM Insights_](/insights)!

<img src="/blog/2023-11-01-rum-archive-one-year-anniversary-insights.png" style="width: 50%; height: auto"/>

[RUM Insights](/insights) captures a collection of basic visualizations for the data contained in the RUM Archive.  It's goal is to allow users to get a feel for the most important insights that can be gained from the data, without having to execute SQL queries themselves.

For more details, check out [Robin Marx](https://twitter.com/programmingart)'s [blog post](/blog/2023-11-01-rum-archive-insights) on the topic or head straight into the [Insights](/insights)!

## Third-Party Resource Data Preview

We've been working on new dataset to complement the [mPulse](/datasets/#akamai-mpulse-rum) Page Load dataset: [Third-Party Resources](/docs/tables/#third-party-resources).

mPulse and boomerang.js capture [ResourceTiming](https://www.w3.org/TR/resource-timing/) data for all of the sub-resources (such as JavaScript, CSS, images, etc) on on every mPulse Page Load beacon.  This data is compressed and beaconed to mPulse for our customers' analytics.

With this data, in aggregate across all of our customers, we can easily spot third-party components (those loaded by multiple customers' domains) such as libraries, analytics scripts, widgets, fonts, etc.

We're going to begin exporting the Top 500+ third-party resources we see each day, similar to how we share Page Load data.  Each third-party resource URL will have information on its [popularity, performance and size](/docs/tables/#third-party-resources).  These URL trends should be trackable over time as well.

For example, here are the Top 10 third-party URLs on 2023-10-15:

```sql
SELECT  URL,
        SUM(FETCHES) AS FETCHES
FROM    akamai-mpulse-rumarchive.rumarchive.rumarchive_resources
WHERE   DATE = '2023-10-15'
GROUP BY URL
ORDER BY SUM(FETCHES) DESC
LIMIT 10
```

| Rank | URL                                               |    FETCHES |
|-----:|---------------------------------------------------|-----------:|
|    1 | `https://www.googletagmanager.com/gtag/js`        | 14,191,855 |
|    2 | `https://www.googletagmanager.com/gtm.js`         |  9,077,607 |
|    3 | `https://www.facebook.com/tr/`                    |  7,848,302 |
|    4 | `https://www.google-analytics.com/j/collect`      |  7,835,923 |
|    5 | `https://www.google-analytics.com/collect`        |  6,579,589 |
|    6 | `https://www.google-analytics.com/analytics.js`   |  4,645,448 |
|    7 | `https://stats.g.doubleclick.net/j/collect`       |  3,755,276 |
|    8 | `https://analytics.google.com/g/collect`          |  3,296,602 |
|    9 | `https://c.go-mpulse.net/api/config.json`         |  2,673,639 |
|   10 | `https://securepubads.g.doubleclick.net/pcs/view` |  2,544,007 |

And here are the most common [initiatorTypes](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceResourceTiming/initiatorType) for the tracked third-party resources:

```sql
SELECT  INITIATORTYPE,
        COUNT(*) AS CNT
FROM    akamai-mpulse-rumarchive.rumarchive.rumarchive_resources
WHERE   DATE = '2023-10-15'
GROUP BY INITIATORTYPE
ORDER BY CNT DESC
```

| INITIATORTYPE    |     CNT |
|:-----------------|--------:|
| `img`            | 421,072 |
| `script`         | 283,536 |
| `xmlhttprequest` | 184,936 |
| `beacon`         |  76,421 |
| `fetch`          |  68,216 |
| `iframe`         |  59,296 |
| `other`          |  42,581 |
| `link`           |  16,156 |
| `css`            |  10,844 |
| (null)           |     565 |

Those are just a few of the insights that can be gleamed from our third-party resource data.  We're looking forward to see what other people find!

This data is available in preview form right now, and we'd love to get more feedback from the community.

For more details, check out our [blog post](/blog/2023-11-01-rum-archive-third-party-resource-data) on the topic!
