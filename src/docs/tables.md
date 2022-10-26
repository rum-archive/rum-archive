---
title: Tables
description: Table structure
layout: layouts/page.njk
tags: docs
order: 2
---

## Overview

The RUM Archive specifies two types of tables:

* **Page Loads**: Browser page load experiences
* **Resources**: Third party resource fetches

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

| Dimension        | Description                       | Example values                      |      Cardinality |
|:-----------------|:----------------------------------|:------------------------------------|-----------------:|
| SOURCE           | Source of the data, e.g. provider | `mpulse`                            |                1 |
| SITE             | Site being measured               | `example.com` `(multiple)`          |                1 |
| DATE             | Date of aggregation               | `2022-01-01`                        | (grows each day) |
| DEVICETYPE       | Device type                       | `Mobile` `Desktop` `Tablet`         |                3 |
| USERAGENTFAMILY  | User Agent family                 | `Chrome` `Mobile Safari`            |             ~100 |
| USERAGENTVERSION | User Agent major version          | `99` `12`                           |             ~350 |
| DEVICEMODEL      | Device model                      | `Apple iPhone` `Samsung Android 11` |            ~2000 |
| OS               | Operating System family           | `Android OS` `Windows` `iOS`        |              ~30 |
| OSVERSION        | Operation System major verison    | `10` `15`                           |              ~75 |
| BEACONTYPE       | Beacon type                       | `page view` `spa hard` `spa`        |                2 |
| COUNTRY          | Country                           | `US` `GB` `GB`                      |             ~230 |
| VISIBILITYSTATE  | Visibility state                  | `visible` `hidden` `partial`        |                3 |
| NAVIGATIONTYPE   | Navigation type                   | `navigate` `back forward` `reload`  |                3 |
| PROTOCOL         | HTTP protocol                     | `h2` `http/1.1` `h3`                |              ~10 |
| IPVERSION        | IP version                        | `IPv4` `IPv6`                       |                3 |
| LANDINGPAGE      | Landing page                      | `true` `false`                      |                3 |

### Timers and Metrics

Each Timer or Metric has 4 columns:

* `*HISTOGRAM` (JSON): [Histogram](/docs/methodology#histogram-format)
* `*AVG` (FLOAT64): Weighted average
* `*SUMLN` (FLOAT64): Sum of the natural logarithms
* `*COUNT` (INTEGER): Number of measurements taken for this timer or metric

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

## Resources

**Coming soon!**
