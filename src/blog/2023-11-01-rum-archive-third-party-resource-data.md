---
title: RUM Archive Third-Party Resource Data
date: 2023-11-01 00:00:02
description: New to the RUM Archive is data on Third-Party Resources.
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /blog/2023-11-01-rum-archive-third-party-resource-data.svg
---

We're excited to announce a **preview** of a new type of data available in the RUM Archive: **Third-Party Resources**

At mPulse, we are using [boomerang.js](https://github.com/akamai/boomerang) to capture RUM data.  Boomerang uses the [ResourceTiming API](https://www.w3.org/TR/resource-timing/) to gather data about all of the sub-resource fetches on the page (such as JavaScript, CSS, images, etc) for every [Page Load beacon](https://techdocs.akamai.com/mpulse-boomerang/docs/whats-in-an-mpulse-beacon).  This data is compressed and beaconed to mPulse for analytics purposes.

From this data, viewed in aggregate across all of our customers, we can easily spot common third-party components such as:

* Tag Managers (Google Tag Manager, GTag)
* Analytics (Google Analytics, mPulse)
* Widgets (Pinterest, Twitter, Bazaar Voice, Youtube)
* Fonts (Google Fonts)
* Beacons (Meta Pixel, mPulse, Google Analytics, Doubleclick)
* Ads (Google, Amazon, Criteo)
* Libraries: (jQuery)

For this new table, we're going to begin exporting the Top 500+ third-party resources we see each day, similar to how we share Page Load data.  Each third-party resource URL will have information on its [popularity, performance and size](/docs/tables/#third-party-resources).  These URL trends should be trackable over time as well.

## Example Queries

Let's look at some example queries for how you can use this data.

It's easy to view the most popular third-party URLs by day.  For example, here are the Top 10 third-party URLs on 2023-10-15:

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

Each URL has multiple [dimensions](/docs/tables/#dimensions-1) associated with it, such as:

* `DEVICETYPE`
* `USERAGENTFAMILY` and `USERAGENTVERSION`
* `DEVICEMODEL`
* `OS` and `OSVERSION`
* `BEACONTYPE`
* `COUNTRY`
* `PROTOCOL`
* `INITIATORTYPE`
* `ASSETTYPE`

Let's look at one of those dimensions. [initiatorTypes](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceResourceTiming/initiatorType) reflects what DOM element triggered the resource fetch.  Here are all of the `initiatorTypes` for these third-party resource URLs in our data, ordered by popularity:

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

You can split, filter and group by other dimensions as well.  For example, let's look at how Google's GTag's median total time (`TOTALHISTOGRAM`) and download time (`DOWNLOADHISTOGRAM`) changes by country (`GROUP BY COUNTRY`) on mobile (`DEVICETYPE=Mobile`) devices:

```sql
SELECT  COUNTRY,
        SUM(FETCHES) AS FETCHES,
        `akamai-mpulse-rumarchive.rumarchive.PERCENTILE_APPROX`(
          ARRAY_AGG(TOTALHISTOGRAM),
          [0.50],
          10,
          false) as TOTAL_MEDIAN,
        `akamai-mpulse-rumarchive.rumarchive.PERCENTILE_APPROX`(
          ARRAY_AGG(DOWNLOADHISTOGRAM),
          [0.50],
          10,
          false) as DOWNLOAD_MEDIAN,
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_resources`
WHERE   DATE = '2023-10-15'
  AND   DEVICETYPE = 'Mobile'
  AND   URL = 'https://www.googletagmanager.com/gtag/js'
GROUP BY COUNTRY
ORDER BY FETCHES DESC
LIMIT 10
```

| COUNTRY |   FETCHES | TOTAL_MEDIAN | DOWNLOAD_MEDIAN |
|:--------|----------:|-------------:|----------------:|
| US      | 3,936,631 |          112 |              25 |
| IN      |   723,496 |          362 |             158 |
| JP      |   536,711 |          131 |              87 |
| GB      |   404,121 |           72 |               7 |
| CA      |   289,541 |          117 |              10 |
| IT      |   184,021 |           96 |             128 |
| BR      |   181,061 |          243 |             157 |
| DE      |   179,368 |           81 |               7 |
| FR      |   171,739 |           79 |               7 |
| MX      |   165,870 |          213 |             335 |

## What URLs are included

Our goal is to share data about the top third-party resource URLs seen across the web.   To start, we plan on sharing the 500+ most popular third-party URLs on a daily basis.

We only consider a URL as being a third-party URL if it shows up in at least 10 _different_ mPulse customer accounts.  We are also reviewing (allowlist-ing) all URLs to ensure they don't contain any customer-specific information.

All URLs have their query string removed, so no sensitive data is shared.

Once a URL makes it into the allowlist, we will continue querying for it even if it drops out of the top 500.  This means the list of URLs will grow slowly over time.

Some URLs share a common pattern with minor differences, such as the `.cc` country code or a `v1.0.0` version number.  Where possible, we'll assign a wildcard `URLGROUP` pattern to these URLs so they can all be tracked as a group.

## Caveats

As with any set of data, this Third-Party Resource data comes with some caveats:

* All ResourceTiming data is subject to [visibility concerns](https://nicj.net/resourcetiming-visibility-third-party-scripts-ads-and-page-weight/):
  * Over 30% of requests are completely hidden from RUM (due to being in a cross-origin `IFRAME`)
  * Over 45% of requests don't have detailed timings or sizes (due to cross-origin restrictions and no `Timing-Allow-Origin` header)
* The mPulse Resources dataset is exactly that -- a reflection of mPulse customers, **not** of the entire internet
* The mPulse data is [sampled](/docs/tips/#data-is-sampled) and raw numbers (e.g. of fetches) should be only used for relative weighting
* All of the other [tips](/docs/tips/) we have on querying RUM Archive data apply

## Feedback Welcome

This is a brand new set of data we're making publicly available.  It may have errors, inconsistencies, quirks, etc.

We'd love to have web performance nerds take a look at the data and give us feedback.  Is it interesting?  Useful?  Does anything seem off?

Please open an [Issue in Github](https://github.com/rum-archive/rum-archive/issues) with any feedback you have!

Thanks!
