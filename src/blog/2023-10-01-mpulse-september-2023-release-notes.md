---
title: mPulse RUM Data Loaded through September 2023, with INP + BFCache
date: 2023-10-01
description: mPulse daily RUM data through September 2023 has been loaded, and now includes Interaction to Next Paint (INP) and Back-Forward Cache (BFCache) data.
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /blog/2023-10-01-mpulse-september-2023-release-notes.svg
---

## Latest mPulse RUM Data Loaded

We've completed an export of mPulse daily RUM data into the BigQuery [`akamai-mpulse-rumarchive`](/datasets/#akamai-mpulse-rum) project up through 2023-09-30.

This brings the RUM Archive's [mPulse dataset](/datasets/#akamai-mpulse-rum) to a running total of 394 straight days of data available since 2022-09-01.  (There is also first-of-month data going back to 2021-10-01).

## Interaction to Next Paint (INP) Data

From 2023-09-01 onward, [Interaction to Next Paint (INP)](https://web.dev/inp/) measurements are now in the mPulse RUM data, as part of the following [columns](/docs/tables/#timers-and-metrics):

* `INPHISTOGRAM` (JSON): [Histogram](/docs/methodology#histogram-format)
* `INPAVG` (FLOAT64): Weighted average
* `INPSUMLN` (FLOAT64): Sum of the natural logarithms
* `INPCOUNT` (INTEGER): Number of measurements taken

At this time, INP data will not be as common as other timers such as Page Load Time (`PLT*`) or even First Input Delay (`FID*`), as capturing the INP measurement requires mPulse customers to be on a recent ([1.766+](https://techdocs.akamai.com/mpulse-boomerang/changelog)) version of [boomerang](https://github.com/akamai/boomerang).

Let's review the current rate of INP data vs. something like FID:

```sql
SELECT  SUM(BEACONS) AS BEACONS,
        SUM(INPCOUNT) AS INP_BEACONS,
        `akamai-mpulse-rumarchive.rumarchive.PERCENTILE_APPROX`(
          ARRAY_AGG(INPHISTOGRAM),
          [0.50],
          100,
          true) as INP_MEDIAN,
        SUM(FIDCOUNT) AS FID_BEACONS,
        `akamai-mpulse-rumarchive.rumarchive.PERCENTILE_APPROX`(
          ARRAY_AGG(FIDHISTOGRAM),
          [0.50],
          100,
          true) as FID_MEDIAN
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2023-09-30"
```

|     BEACONS | INP_BEACONS | INP_MEDIAN | FID_BEACONS | FID_MEDIAN |
|------------:|------------:|-----------:|------------:|-----------:|
| 169,613,083 |   5,806,935 |        518 |  22,833,581 |        159 |

So as of 2023-09-30, out of 169.6m beacons, there were 5.8m datapoints for INP, vs. ~22.8m for FID.  The INP rate should grow over time, as mPulse customers upgrade their boomerang.js versions, and as more visitors use browsers that support EventTiming/INP.

One caveat for INP data in mPulse: boomerang.js only measures INP up to the point of the first beacon, which is usually the page load event.  For Single Page App (SPA) sites, INP data is also split by SPA Soft Navigations.  Due to this, mPulse INP measurements may be less than CrUX INP measurements.

## Back-Forward Cache (BFCache) Navigation Data

From 2023-09-01 onward, [Back-Forward Cache (BFCache) Navigations](https://web.dev/articles/bfcache) are now included in the mPulse RUM data, and can be detected by looking for `bfcache` in the [`BEACONTYPE` column](/docs/tables/#dimensions).

BFCache data is still very small in the mPulse dataset since it requires an update to [boomerang.js 1.785+](https://techdocs.akamai.com/mpulse-boomerang/changelog).

As of 2023-09-30, we're seeing about 0.05% of beacons coming from BFCache navigations:

```sql
-- Relative popularity of each Beacon Type
SELECT  beaconType,
        SUM(BEACONS) AS BEACONCOUNT,
        (
          SUM(BEACONS) /
            (SELECT SUM(BEACONS)
             FROM `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
             WHERE DATE = '2023-09-30')
        ) AS BEACONPCT
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = '2023-09-30'
GROUP BY beaconType
ORDER BY BEACONCOUNT DESC
```

| BEACONTYPE  | BEACONCOUNT | BEACONPCT |
|:------------|------------:|----------:|
| `page view` | 102,251,908 |     60.2% |
| `spa`       |  34,555,519 |     20.3% |
| `spa hard`  |  32,709,307 |     19.2% |
| `bfcache`   |      96,349 |     0.05% |

**This should not** be interpreted that only 0.05% of navigations _across the web_ are BFCache, as the incoming BFCache data is limited to only mPulse customers using the latest cutting-edge version of boomerang.js.  I'd expect the BFCache rate to rise as adoption of the new version of boomerang.js increases.  

For sites that _have_ upgraded to the latest version of boomerang.js, and that don't have any blockers for BFCache, they are seeing a much higher rate of BFCache vs. `page view`s.  However, the mPulse dataset has data from the Top 100 sites mixed together, so we can't separate the data to only review sites that are on the latest boomerang.js.
