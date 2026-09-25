---
title: Tables
description: Table structure
layout: layouts/page.njk
tags: docs
order: 2
---

## Overview

The RUM Archive specifies two types of tables:

* `page_loads`: Browser page load experiences
* `resources`: Third party resource fetches

All tables are **partitioned** by the `DATE` column to assist with reducing the amount of data queried.  We [suggest](/docs/tips) you limit all queries to a specific date (or date range) to limit your BigQuery query costs.

## Page Loads

Page Loads represent browser navigation experiences, whether from a traditional Multi-Page App (MPA) or Single-Page App (SPA).  SPA navigations can be broken down into both Hard Navigations (the first navigation to the page) and Soft Navigations (in-page route changes).

Data is aggregated for each date.

### Schema

```sql
{% include "../../../samples/bigquery/schemas/create-table-page-loads.sql" %}
```

### Dimensions

The dimensions below are characteristics of the Page Load experience.

Not every [dataset](/datasets) populates every dimension.  Dimensions a dataset does not have data for are exported as
empty strings.

The _Cardinality_ column is an estimate from the mPulse dataset (or, for dimensions mPulse does not populate, the
Cloudflare dataset).

<div class="table-container">

| Dimension                | Description                                                         | Example values                                          |      Cardinality |
|:-------------------------|:--------------------------------------------------------------------|:--------------------------------------------------------|-----------------:|
| `SOURCE`                 | Source of the data, e.g. provider                                   | `mpulse` `cloudflare`                                   |                1 |
| `SITE`                   | Site being measured                                                 | `example.com` `(multiple)`                              |                1 |
| `DATE`                   | Date of aggregation                                                 | `2022-01-01`                                            | (grows each day) |
| `DEVICETYPE`             | Device type                                                         | `Mobile` `Desktop` `Tablet`                             |                3 |
| `USERAGENTFAMILY`        | User Agent family                                                   | `Chrome` `Mobile Safari`                                |             ~100 |
| `USERAGENTVERSION`       | User Agent major version                                            | `124` `12` (Safari: `17.4`)                             |             ~350 |
| `USERAGENTENGINE`        | Browser engine family                                               | `Blink` `WebKit` `Gecko`                                |               ~3 |
| `USERAGENTENGINEVERSION` | Browser engine major version                                        | `139` `18.5`                                            |             ~900 |
| `DEVICEMODEL`            | Device model                                                        | `Apple iPhone` `Samsung Android 11`                     |            ~2000 |
| `OS`                     | Operating System family                                             | `Android OS` `Windows` `iOS`                            |              ~30 |
| `OSVERSION`              | Operation System major version                                      | `10` `15` (iOS: `17.4`)                                 |              ~75 |
| `BEACONTYPE`             | Beacon type                                                         | `page view` `spa hard` `spa` `bfcache`                  |                4 |
| `COUNTRY`                | Country                                                             | `US` `GB` `GB`                                          |             ~230 |
| `VISIBILITYSTATE`        | Visibility state                                                    | `visible` `hidden` `partial`                            |                3 |
| `NAVIGATIONTYPE`         | Navigation type                                                     | `navigate` `back forward` `reload` `back forward cache` |               ~8 |
| `PROTOCOL`               | HTTP protocol                                                       | `h2` `http/1.1` `h3`                                    |              ~10 |
| `IPVERSION`              | IP version                                                          | `IPv4` `IPv6`                                           |                3 |
| `LANDINGPAGE`            | Landing page                                                        | `true` `false`                                          |                3 |
| `INDUSTRY`               | Industry of the site [<sup>_1_</sup>](#page-loads-dimensions-notes) | `Technology` `Shopping & Auctions` `Sports` `Unknown`   |               24 |

</div>

<a name="page-loads-dimensions-notes"></a>
Notes:

1. `INDUSTRY` is set by the dataset provider based on its own categorization of the site.  The Cloudflare dataset uses
   Cloudflare's domain categories, and reports `Unknown` for any site it cannot confidently categorize.  Possible values are
   `Ads`, `Adult Themes`, `Always Blocked`, `Business & Economy`, `CIPA`, `Education`, `Entertainment`, `Government & Politics`,
   `Health`, `Internet Communication`, `Job Search & Careers`, `Miscellaneous`, `Real Estate`,
   `Religion`, `Safe for Kids`, `Shopping & Auctions`, `Society & Lifestyle`,
   `Sports`, `Technology`, `Travel`, `Vehicles`, `Violence`, `Weather` and `Unknown`.

### Timers and Metrics

The `BEACONS` column contains how many Page Loads that row represents.

Each Timer or Metric has 4 columns:

* `*HISTOGRAM` (JSON): [Histogram](/docs/methodology#histogram-format)
* `*AVG` (FLOAT64): Weighted average
* `*SUMLN` (FLOAT64): Sum of the natural logarithms
* `*COUNT` (INTEGER): Number of measurements taken for this timer or metric

Not every [dataset](/datasets) populates every Timer or Metric.  Those a dataset does not have data for are exported with
an empty `*HISTOGRAM`, a `NULL` `*AVG` and `*SUMLN`, and a `*COUNT` of `0`.

<div class="table-container">

| Timer or Metric                                                           | Column Name Prefix      |
|:--------------------------------------------------------------------------|:------------------------|
| Page Load Time                                                            | `PLT`                   |
| DNS                                                                       | `DNS`                   |
| TCP                                                                       | `TCP`                   |
| TLS                                                                       | `TLS`                   |
| Time to First Byte                                                        | `TTFB`                  |
| First Contentful Paint                                                    | `FCP`                   |
| Largest Contentful Paint                                                  | `LCP`                   |
| Round Trip Time                                                           | `RTT`                   |
| Rage Clicks                                                               | `RAGECLICKS`            |
| Cumulative Layout Shift (*1000)                                           | `CLS`                   |
| First Input Delay                                                         | `FID`                   |
| Interaction to Next Paint                                                 | `INP`                   |
| Total Blocking Time                                                       | `TBT`                   |
| Time to Interactive                                                       | `TTI`                   |
| Redirect                                                                  | `REDIRECT`              |
| Unattributed Navigation Overhead                                          | `UNO`                   |
| Transfer Size (bytes) [<sup>_1_</sup>](#page-loads-timers-notes)          | `TRANSFERSIZE`          |
| Time to First Interim Response [<sup>_2_</sup>](#page-loads-timers-notes) | `INTERIMRESPONSE`       |
| LCP: Resource Load Delay [<sup>_3_</sup>](#page-loads-timers-notes)       | `LCPLOADDELAY`          |
| LCP: Resource Load Duration [<sup>_3_</sup>](#page-loads-timers-notes)    | `LCPLOADTIME`           |
| LCP: Element Render Delay [<sup>_3_</sup>](#page-loads-timers-notes)      | `LCPRENDERDELAY`        |
| INP: Input Delay [<sup>_4_</sup>](#page-loads-timers-notes)               | `INPINPUTDELAY`         |
| INP: Processing Duration [<sup>_4_</sup>](#page-loads-timers-notes)       | `INPPROCESSINGDURATION` |
| INP: Presentation Delay [<sup>_4_</sup>](#page-loads-timers-notes)        | `INPPRESENTATIONDELAY`  |

</div>

<a name="page-loads-timers-notes"></a>
Notes:

1. `TRANSFERSIZE` is the [`transferSize`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceResourceTiming/transferSize)
   of the HTML document itself (in **bytes**, not milliseconds), so it reflects how much the browser had to download for
   the main document.
2. `INTERIMRESPONSE` is the time to
   [`firstInterimResponseStart`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceNavigationTiming/firstInterimResponseStart),
   i.e. the first `1xx` informational response such as
   [`103 Early Hints`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/103).  It is only measured for
   navigations that received an interim response.
3. The three `LCP*` sub-parts break Largest Contentful Paint down into the phases that produced it, as defined by the
   [`web-vitals` LCP attribution](https://github.com/GoogleChrome/web-vitals#lcpattribution) contract:
   `TTFB` + `LCPLOADDELAY` + `LCPLOADTIME` + `LCPRENDERDELAY` rougly equals `LCP` for a given page load.
4. The three `INP*` sub-parts break Interaction to Next Paint down into the phases that produced it, as defined by the
   [`web-vitals` INP attribution](https://github.com/GoogleChrome/web-vitals#inpattribution) contract:
   `INPINPUTDELAY` + `INPPROCESSINGDURATION` + `INPPRESENTATIONDELAY` equals `INP` for a given interaction.  Unlike the
   other paint and interaction timers, `0` is a **valid measurement** for these sub-parts (for example, an interaction
   with no JavaScript handler has a `0` Processing Duration), so zeros are kept rather than treated as "not measured".

## Third-Party Resources

Third-Party Resources represent URLs (such as JavaScript, CSS, images, etc) have been seen across multiple websites and are third-party components such as libraries, analytics scripts, widgets, fonts, etc.

Data is aggregated for each date.


### Schema

```sql
{% include "../../../samples/bigquery/schemas/create-table-resources.sql" %}
```

### Dimensions

The dimensions below are characteristics of the Page Load experience.

The _Cardinality_ column is an estimate from the mPulse dataset.

<div class="table-container">

| Dimension          | Description                                                                                                | Example values                                                                 |      Cardinality |
|:-------------------|:-----------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------|-----------------:|
| `SOURCE`           | Source of the data, e.g. provider                                                                          | `mpulse`                                                                       |                1 |
| `SITE`             | Site being measured                                                                                        | `example.com` `(multiple)`                                                     |                1 |
| `DATE`             | Date of aggregation                                                                                        | `2022-01-01`                                                                   | (grows each day) |
| `URLGROUP`         | Group the URL belongs to                                                                                   | `https://thirdparty.com/analytics/*.js`                                        |              ~20 |
| `URL`              | Third-Party Resource URL                                                                                   | `https://thirdparty.com/analytics/v1.js`                                       |           < 1000 |
| `DEVICETYPE`       | Device type                                                                                                | `Mobile` `Desktop` `Tablet`                                                    |                3 |
| `USERAGENTFAMILY`  | User Agent family                                                                                          | `Chrome` `Mobile Safari`                                                       |             ~100 |
| `USERAGENTVERSION` | User Agent major version                                                                                   | `124` `12` (Safari: `17.4`)                                                    |             ~350 |
| `DEVICEMODEL`      | Device model                                                                                               | `Apple iPhone` `Samsung Android 11`                                            |            ~2000 |
| `OS`               | Operating System family                                                                                    | `Android OS` `Windows` `iOS`                                                   |              ~30 |
| `OSVERSION`        | Operation System major version                                                                             | `10` `15` (iOS: `17.4`)                                                        |              ~75 |
| `BEACONTYPE`       | Beacon type                                                                                                | `page view` `spa hard` `spa` `bfcache`                                         |                4 |
| `COUNTRY`          | Country                                                                                                    | `US` `GB` `GB`                                                                 |             ~230 |
| `PROTOCOL`         | HTTP protocol                                                                                              | `h2` `http/1.1` `h3`                                                           |              ~10 |
| `INITIATORTYPE`    | [Initiator Type](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceResourceTiming/initiatorType) | `fetch` `link` `css` `iframe` `img` `xmlhttprequest` `beacon` `script` `other` |                9 |
| `ASSETTYPE`        | mPulse Asset Type                                                                                          | `img` `font` `html` `js` `bcn` `xhr` `css` `other`                             |                8 |

</div>

### Timers and Metrics

The `FETCHES` column contains how many resource fetches that row represents.

Each Timer or Metric has 4 columns:

* `*HISTOGRAM` (JSON): [Histogram](/docs/methodology#histogram-format)
* `*AVG` (FLOAT64): Weighted average
* `*SUMLN` (FLOAT64): Sum of the natural logarithms
* `*COUNT` (INTEGER): Number of measurements taken for this timer or metric

<div class="table-container">

| Timer or Metric    | Column Name Prefix |
|:-------------------|:-------------------|
| Total Time         | `TOTAL`            |
| DNS Time           | `DNS`              |
| TCP Time           | `TCP`              |
| TLS Time           | `TLS`              |
| Request Time       | `REQUEST`          |
| Response Time      | `RESPONSE`         |
| Time to First Byte | `TTFB`             |
| Download Time      | `DOWNLOAD`         |
| Redirect Time      | `REDIRECT`         |
| Cached             | `CACHED`           |
| Encoded Body Size  | `ENCODEDSIZE`      |
| Decoded Body Size  | `DECODEDSIZE`      |
| Transfer Size      | `TRANSFERSIZE`     |

</div>
