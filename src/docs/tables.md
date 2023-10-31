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

The _Cardinality_ column is an estimate from the mPulse dataset.

<div class="table-container">

| Dimension          | Description                       | Example values                         |      Cardinality |
|:-------------------|:----------------------------------|:---------------------------------------|-----------------:|
| `SOURCE`           | Source of the data, e.g. provider | `mpulse`                               |                1 |
| `SITE`             | Site being measured               | `example.com` `(multiple)`             |                1 |
| `DATE`             | Date of aggregation               | `2022-01-01`                           | (grows each day) |
| `DEVICETYPE`       | Device type                       | `Mobile` `Desktop` `Tablet`            |                3 |
| `USERAGENTFAMILY`  | User Agent family                 | `Chrome` `Mobile Safari`               |             ~100 |
| `USERAGENTVERSION` | User Agent major version          | `99` `12`                              |             ~350 |
| `DEVICEMODEL`      | Device model                      | `Apple iPhone` `Samsung Android 11`    |            ~2000 |
| `OS`               | Operating System family           | `Android OS` `Windows` `iOS`           |              ~30 |
| `OSVERSION`        | Operation System major version    | `10` `15`                              |              ~75 |
| `BEACONTYPE`       | Beacon type                       | `page view` `spa hard` `spa` `bfcache` |                4 |
| `COUNTRY`          | Country                           | `US` `GB` `GB`                         |             ~230 |
| `VISIBILITYSTATE`  | Visibility state                  | `visible` `hidden` `partial`           |                3 |
| `NAVIGATIONTYPE`   | Navigation type                   | `navigate` `back forward` `reload`     |                3 |
| `PROTOCOL`         | HTTP protocol                     | `h2` `http/1.1` `h3`                   |              ~10 |
| `IPVERSION`        | IP version                        | `IPv4` `IPv6`                          |                3 |
| `LANDINGPAGE`      | Landing page                      | `true` `false`                         |                3 |

</div>

### Timers and Metrics

The `BEACONS` column contains how many Page Loads that row represents.

Each Timer or Metric has 4 columns:

* `*HISTOGRAM` (JSON): [Histogram](/docs/methodology#histogram-format)
* `*AVG` (FLOAT64): Weighted average
* `*SUMLN` (FLOAT64): Sum of the natural logarithms
* `*COUNT` (INTEGER): Number of measurements taken for this timer or metric

<div class="table-container">

| Timer or Metric                 | Column Name Prefix |
|:--------------------------------|:-------------------|
| Page Load Time                  | `PLT`              |
| DNS                             | `DNS`              |
| TCP                             | `TCP`              |
| TLS                             | `TLS`              |
| Time to First Byte              | `TTFB`             |
| First Contentful Paint          | `FCP`              |
| Largest Contentful Paint        | `LCP`              |
| Round Trip Time                 | `RTT`              |
| Rage Clicks                     | `RAGECLICKS`       |
| Cumulative Layout Shift (*1000) | `CLS`              |
| First Input Delay               | `FID`              |
| Interaction to Next Paint       | `INP`              |
| Total Blocking Time             | `TBT`              |
| Time to Interactive             | `TTI`              |
| Redirect                        | `REDIRECT`         |

</div>

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
| `USERAGENTVERSION` | User Agent major version                                                                                   | `99` `12`                                                                      |             ~350 |
| `DEVICEMODEL`      | Device model                                                                                               | `Apple iPhone` `Samsung Android 11`                                            |            ~2000 |
| `OS`               | Operating System family                                                                                    | `Android OS` `Windows` `iOS`                                                   |              ~30 |
| `OSVERSION`        | Operation System major version                                                                             | `10` `15`                                                                      |              ~75 |
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