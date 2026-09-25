---
title: The Cloudflare BEACON Dataset
date: 2026-09-28
description: Cloudflare is contributing a new cross-browser, internet-scale dataset to the RUM Archive!
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /assets/cloudflare-logo.svg
---

![Cloudflare Logo](/assets/cloudflare-logo.png)

Today we're announcing the largest addition to the RUM Archive since the project began: the
[**Cloudflare BEACON Dataset**](/datasets/#cloudflare-beacon-dataset).

[Cloudflare](https://www.cloudflare.com) is contributing daily, aggregated and anonymized Real User Monitoring data
collected by [Cloudflare RUM](https://www.cloudflare.com/web-analytics/) to the RUM Archive, under the same
[CC BY SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) license and in the same
[format](/docs/tables) as the existing datasets.

Along with the data, Cloudflare is contributing **11 new columns** to the RUM Archive Page Loads format, including
Industry and Browser Engine dimensions, and Largest Contentful Paint and Interaction to Next Paint sub-parts metrics.

## Why another dataset?

The RUM Archive has always had two goals: to publish real user data, and to define a **shared format** that anyone can
publish real user data in.  Each new dataset makes the project more useful, because each one brings a different view of
the web.

Until today, the only page load data in the RUM Archive came from [Akamai mPulse](/datasets/#akamai-mpulse-rum): a
sample of mPulse's top 100 (by volume) customers.

The most widely-used public performance dataset outside of the RUM Archive is Google's
[Chrome User Experience Report](https://developer.chrome.com/docs/crux) (CrUX), which covers millions of websites but, by
design, only reports data from **Chrome**.  If you want to know how Safari on an older iPhone performs, or how Firefox
compares to Chrome on the same websites, CrUX can't tell you.

Cloudflare sits in front of millions of websites and measures page loads from **every** browser that visits them, so
this dataset fills in the part of the picture the other two can't:

<div class="table-container">

| Dataset                            | Scale                | Browsers     |
|:-----------------------------------|:---------------------|:-------------|
| Google CrUX                        | Millions of websites | Chrome only  |
| Akamai mPulse (in the RUM Archive) | Top 100 websites     | All browsers |
| Cloudflare (in the RUM Archive)    | Top 10,000 websites  | All browsers |

</div>

## What's in the dataset

The full details are on the [datasets](/datasets/#cloudflare-beacon-dataset) page, but the highlights:

* It's published daily to the public `cf-open-web-performance.rumarchive.rumarchive_page_loads` BigQuery table, starting
  with `2026-09-20` data
* `SOURCE` is `cloudflare` and `SITE` is `(multiple)`, so the websites are **not** individually identifiable
* Each day, up to the top 10,000 Cloudflare websites (by page load volume) are aggregated
  * Every website is capped at the **same** number of page loads, so no single large website can dominate the dataset --
    a query for "median LCP in Germany" reflects thousands of websites, not just the biggest one
  * Page loads from known bot and automation User Agents are excluded
* A [Minimum Count Threshold](/docs/methodology/#minimum-count-threshold) of 5 is applied, same as mPulse
* The schema and histogram [bucketing](/docs/methodology/#histogram-bucketing) are identical to the mPulse dataset,
  so **your existing queries work** with just a table name change

There are some gaps to be aware of.  The `DEVICEMODEL`, `VISIBILITYSTATE` and `IPVERSION` dimensions and the `RTT`,
`RAGECLICKS`, `FID`, `TBT`, `TTI` and `UNO` metrics aren't measured by Cloudflare RUM today, so they're
exported empty.  Single Page App navigations aren't reported yet either, so `BEACONTYPE` is limited to `page view` and
`bfcache`.  We're looking into publishing some of those dimensions and metrics in the future.

## 11 new columns

The more interesting contribution may be to the format itself.  Version
[1.6](/docs/release-notes) of the RUM Archive adds 3 new [dimensions](/docs/tables#dimensions) and 8 new
[timers and metrics](/docs/tables#timers-and-metrics).  All of them are additive, and datasets that don't have data for
them export empty values, so **existing queries keep working**.

### New dimensions

* `USERAGENTENGINE` and `USERAGENTENGINEVERSION`: the browser **engine** family and major version (`Blink`, `WebKit`,
  `Gecko`).  Browser engines are often what actually determines behaviour -- every browser on
  iOS is WebKit, and Edge, Chrome and Opera are all Blink.
* `INDUSTRY`: the industry category of the website (`Technology`, `Shopping & Auctions`, `Sports`, ...).  Web performance
  expectations are not the same for a news site and a checkout flow, and this makes it possible to compare like with
  like.

### New timers and metrics

* `TRANSFERSIZE`: how many **bytes** the browser downloaded for the HTML document itself
* `INTERIMRESPONSE`: the time to the first interim (`1xx`) response, such as
  [`103 Early Hints`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/103)
* `LCPLOADDELAY`, `LCPLOADTIME`, `LCPRENDERDELAY`: the Largest Contentful Paint **sub-parts**
* `INPINPUTDELAY`, `INPPROCESSINGDURATION`, `INPPRESENTATIONDELAY`: the Interaction to Next Paint **sub-parts**

The sub-parts are the ones we're most excited about.  Core Web Vitals tell you _that_ a page is slow or unresponsive; the
sub-parts tell you _why_, and each one points at a different fix.  A high `LCPLOADDELAY` means the hero image was
discovered late.  A high `LCPLOADTIME` means it's too big.  A high `LCPRENDERDELAY` means something blocked rendering
after it arrived.  Same for interactivity: `INPINPUTDELAY` means the main thread was already busy, and
`INPPROCESSINGDURATION` means the event handler itself ran long.

Both breakdowns are additive, per the
[`web-vitals` attribution](https://github.com/GoogleChrome/web-vitals#inpattribution) contract:

* `TTFB` + `LCPLOADDELAY` + `LCPLOADTIME` + `LCPRENDERDELAY` ~= `LCP`
* `INPINPUTDELAY` + `INPPROCESSINGDURATION` + `INPPRESENTATIONDELAY` ~= `INP`

One important detail if you query the INP sub-parts: unlike the other paint and interaction timers, `0` is a **valid
measurement** here.  An interaction with no JavaScript handler attached legitimately has a `0` Processing Duration, and
that's the _best_ possible outcome, so zeros are kept in the data rather than being treated as "not measured".  Pass
`includeZero = true` to `PERCENTILE_APPROX()` when calculating percentiles for these columns, or you'll throw away the
fastest interactions.

## Querying it

The [querying guide](/docs/querying) applies as-is.  Star the `cf-open-web-performance` project in your BigQuery console
instead of (or in addition to) `akamai-mpulse-rumarchive`, then query away.

For example, here's the P75 LCP by browser engine, for mobile devices, in the Netherlands, for a single day:

```sql
SELECT  USERAGENTENGINE,
        SUM(BEACONS) AS BEACONCOUNT,
        CAST(`cf-open-web-performance.rumarchive.PERCENTILE_APPROX`(
            ARRAY_AGG(LCPHISTOGRAM), [0.75], 100, false) AS INTEGER) AS LCP_P75
FROM    `cf-open-web-performance.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2026-09-28"
  AND   DEVICETYPE = "Mobile"
  AND   USERAGENTENGINE != ""
  AND   COUNTRY = "NL"
GROUP BY USERAGENTENGINE
ORDER BY SUM(BEACONS) DESC
```

And here's where Largest Contentful Paint time actually goes, by country:

```sql
SELECT  COUNTRY,
        SUM(BEACONS) AS BEACONCOUNT,
        CAST(`cf-open-web-performance.rumarchive.PERCENTILE_APPROX`(
            ARRAY_AGG(LCPHISTOGRAM), [0.75], 100, true) AS INTEGER) AS LCP_P75,
        CAST(`cf-open-web-performance.rumarchive.PERCENTILE_APPROX`(
            ARRAY_AGG(TTFBHISTOGRAM), [0.75], 10, true) AS INTEGER) AS TTFB_P75,
        CAST(`cf-open-web-performance.rumarchive.PERCENTILE_APPROX`(
            ARRAY_AGG(LCPLOADDELAYHISTOGRAM), [0.75], 100, true) AS INTEGER) AS LOADDELAY_P75,
        CAST(`cf-open-web-performance.rumarchive.PERCENTILE_APPROX`(
            ARRAY_AGG(LCPLOADTIMEHISTOGRAM), [0.75], 100, true) AS INTEGER) AS LOADTIME_P75,
        CAST(`cf-open-web-performance.rumarchive.PERCENTILE_APPROX`(
            ARRAY_AGG(LCPRENDERDELAYHISTOGRAM), [0.75], 100, true) AS INTEGER) AS RENDERDELAY_P75
FROM    `cf-open-web-performance.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2026-09-28"
GROUP BY COUNTRY
ORDER BY SUM(BEACONS) DESC
```

Remember to always filter on `DATE` -- it's the partitioning column, and it's the easiest way to keep your BigQuery
costs down.  See our [tips](/docs/tips) for more.

## What's next

This is the first release, and it won't be the last.  On the roadmap:

* Filling in the dimensions and metrics that are currently empty
* Higher-cardinality companion tables (for example, per-User-Agent-version and per-network/ASN breakdowns) that would
  split the main table too finely

If you build something with this data, we'd love to hear about it -- and if you have RUM data of your own to share,
please [contribute](/contribute)!
