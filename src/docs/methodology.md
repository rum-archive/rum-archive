---
title: Methodology
description: How the RUM data is gathered, aggregated and exported.
layout: layouts/page.njk
tags: docs
order: 0
---

## Overview

The RUM Archive datasets contain aggregated Real User Monitoring (RUM) data from one or more websites.

Each public [dataset](/datasets) publishes to Google BigQuery tables.

Two primary tables are described within the RUM Archive:

* Page Loads
* Resources

The documentation on this page describes how this RUM data is aggregated, exported and made available for querying.

## Aggregation

All data published to the RUM Archive is **aggregated** -- that is, there are no individual user experiences, beacons,
hits, page loads or fetches represented within the queryable data.

The goal of aggregation is twofold:

* To protect the privacy of the individual user who generated the data
* To reduce the amount of data that needs to be queried so that vast quantities of data can be represented

In order to generate queryable aggregated data, the RUM Archive tables share a common pattern in the columns they contain:

* Multiple **dimensions** that describe the aggregate data, such as date, browser, geographic region, or protocol
    * Each row represents a unique tuple of those dimensions
* A **Count** of the number of datapoints that match that unqiue tuple
* **Timer or metrics** that are aggregated into Histograms and other statistics like Avg or SumLn

With the data exported in this format, anyone wanting to combine, aggregate, slice, filter or group by any of the available
dimensions can also calculate statistics about that group of data:

* By using the **Histogram** columns, queries can calculate **approxiamte percentiles** of the data (from 0 to 100).
* By using the **Avg** columns and **Count** columns, queries can calculate the **average** of data.
* By using the **SumLn** and **Count** columns, queries can calculate the **geometric mean** of data.

### Minimum Count Threshold

Some datasets may have a Minimum Count Threshold for aggregated data.  For example, the mPulse [dataset](/datasets) has
a Minimum Page Loads Count Threhold of 5, so all any tuples in the exported data that aren't represented by at least 5
unique hits will be discarded.

This threshold is intended to ensure individual experiences are not directly represented within the sample set.  If the
Minimum Count Threshold was 1, rows with a Count of 1 would represent an individual experience.

The downside of appling a Minimum Count Threshold is that **outliers**, by definition, will be discarded and not represented
in the queryable dataset.  Please see the [tips](/docs/tips) section for details on how this may affect queries.

TODO show examples of min threshold how it affects median etc

## Bucketing

RUM Archive tables contain several Histogram columns, one for each timer or metric that is aggregated.

These Histogram columns are used to calculate approximate percentiles of the data.

Each Histogram is a frequency distribution of datapoints for that timer/metric, according to the bucket widths decribed below.

All Histograms contain 151 buckets:

* Zero values: 1 bucket
* High precision: 100 buckets
* Low precision: 50 buckets

High precision buckets are on the low end of the expected value range, and represent values that the impact of the metric
changing is the highest.  For example, Page Load Time's High Precision buckets start at 0 and go to 10,000ms in 100 equally-sized
100ms buckets.

Low precision buckets extend to the numbers beyond the High Max, using buckets 10x the width of the High Width.  For example,
Page Load Time's Low Precision buckets start at 10,0001ms and extend to 60,000ms in 50 equally-sized 1,000ms buckets.

Having both High precision and Low precision buckets allows us to represent data from a large range of possible values while
still providing high precision to the values that matter most (on the low end of the range).

By combining all of the Histograms for columns matching a query, and running the [fast histogram](/docs/querying) algorithm
on the combined Histograms, one can calculate the approxiamte percentile for any desired percentile.

### Page Loads

Page Loads have following bucket histogram definitions:
​
| Metric                          | Column Name           | High Width | High Min | High Max | Low Width | Low Min | Low Max |
|:--------------------------------|:----------------------|-----------:|---------:|---------:|----------:|--------:|--------:|
| Page Load Time                  | `pltHistogram`        |        100 |        0 |   10,000 |     1,000 |  10,001 |  60,000 |
| DNS                             | `dnsHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| TCP                             | `tcpHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| TLS                             | `tlsHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Time to First Byte              | `ttfbHistogram`       |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| First Contentful Paint          | `fcpHistogram`        |        100 |        0 |   10,000 |     1,000 |  10,001 |  60,000 |
| Largest Contentful Paint        | `lcpHistogram`        |        100 |        0 |   10,000 |     1,000 |  10,001 |  60,000 |
| Round Trip Time                 | `rttHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Rage Clicks                     | `rageClicksHistogram` |          1 |        0 |      100 |        10 |     101 |     600 |
| Cumulative Layout Shift (*1000) | `clsHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| First Input Delay               | `fidHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Interaction to Next Paint       | `inpHistogram`        |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Total Blocking Time             | `tbtHistogram`        |        100 |        0 |   10,000 |     1,000 |  10,001 |  60,000 |
| Time to Interactive             | `ttiHistogram`        |        100 |        0 |   10,000 |     1,000 |  10,001 |  60,000 |
| Redirect                        | `redirectHistogram`   |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |

### Resources

Resource Fetches have following bucket histogram definitions:

| Metric             | Column Name             | High Width | High Min | High Max | Low Width | Low Min | Low Max |
|:-------------------|:------------------------|-----------:|---------:|---------:|----------:|--------:|--------:|
| Total              | `totalHistogram`        |         10 |        0 |    10,00 |       100 |   1,001 |   6,000 |
| DNS                | `dnsHistogram`          |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| TCP                | `tcpHistogram`          |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| TLS                | `tlsHistogram`          |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Time to First Byte | `ttfbHistogram`         |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Download           | `downloadHistogram`     |         10 |        0 |    1,000 |       100 |   1,001 |   6,000 |
| Transfer Size      | `transferSizeHistogram` |        100 |        0 |   10,000 |     1,000 |  10,001 |  60,000 |
