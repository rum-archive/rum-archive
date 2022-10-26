---
title: Tips
description: Tips and caveats for querying RUM Archive data.
layout: layouts/page.njk
tags: docs
order: 4
---

## Data is sampled

All of the data in the RUM Archive is **sampled**.

The sampling rate may not be publicly disclosed, so `BEACONS` counts should only be used for [_relative_ weighting](#counts-should-only-be-used-for-relative-percentages) for that day.

The sampling rate _may_ also change from day-to-day.

_Relative_

## Counts should only be used for relative percentages

Since the [data is sampled](#data-is-sampled), absolute counts of `BEACONS` should only be used to compare data on the same `DATE` in a single dataset.

As the sampling rate may change from day-to-day, absolute count comparisons _between days_ should not be used, only _relative weights_.

See the [sample queryies](/docs/samples/#dimension-popularity-(as-a-percentage-of-total)) for examples of how to calculate relative weights.

## Outliers are excluded

All of the data in the RUM Archive is [sampled](#data-is-sampled), [aggregated](/docs/methodology/#aggregation), and only rows that meet the [Minimum Count Threshold](/docs/methodology/#minimum-count-threshold) are included.

The downside of appling a Minimum Count Threshold is that **outliers**, by definition, will be discarded and not represented
in the queryable dataset.

Discarding outliers **will affect** the accuracy of queries.  For example, in the mPulse dataset, we estimate that discarding any tuples with less than 5 hits could affect 50th percentile (median) calculations by around 2.9% and 95th percentile calculations by 7%.  Please take this into consideration when querying the data.

## Zeroes matter (or not)

When querying Timer or Metric percentiles via the [`PERCENTILE_APPROX`](/docs/querying/#approximate-percentiles) function, you will need to consider whether you want to include "zeros" in the percentile calculation.

For some Timers or Metrics, including zeros makes sense.  For example, Cumulative Layout Shifts can have a value of `0.0`, meaning no shifts happened.  This is **good** and represents the ideal page load (no shifts).  Including zeros will likely "shift" the `PERCENTILE_APPROX` calculation left (lower), by including those `0.0` page loads.

For other Timers like DNS, you may want to include or exclude zeros:

* If you're including zeros, you're including all page loads, even those that had no DNS lookup time (e.g. because DNS was cached).  This would be done to understand the percentile of DNS time for **all** of your page visits, whether or not they had to do a DNS lookup.
* If you're **not** including zeros, you're only including page loads that had a DNS lookup (e.g. excluding those that had DNS cached).  This would be done to understand the DNS lookup time **when** DNS had to be queried.

## Data sets should not be compared

Each [dataset](/datasets) comes from a different website (or set of websites), and is using a different collection, sampling and aggregation methodology.

As a result, datasets shouldn't be directly compared to one another unless you're looking at specific things that would not be affected by those caveats (such as understanding the relative weighting of Browser or Device Types seen).

## Limiting BigQuery costs

RUM Archive [tables](/tables) are partitioned by `DATE` to aid in reducing query costs.  When you're issuing a BigQuery query, you should almost always be using a `DATE` clause.

If you don't include a `DATE` clause, BigQuery may have to query the entire dataset.  Some datasets could be 100s of GBs or larger.

For example, a single day in the [mPulse RUM dataset](/datasets) should only be 3-5 GB.  After a year of data, the entire mPulse dataset could be 2 TB or larger.

You may want to review what's available in the [BigQuery free tier](https://cloud.google.com/bigquery/pricing#free-tier), to try to stay under those limits.  With 1 TB of free queries, you should be able to run a few hundred queries against the mPulse dataset, when using a `DATE` filter.

BigQuery has an estimated query cost (in bytes) in the upper-right corner of the BigQuery console:

![Estimating BigQuery costs](/assets/tips-limiting-bigquery-costs-1.png)

## BigQuery UDF Out of Memory

When using the [`PERCENTILE_APPROX`](docs/querying/#approximate-percentiles) function, BigQuery may run out of memory:

![Estimating BigQuery costs](/assets/tips-bigquery-udf-out-of-memory-1.png)

This is because `PERCENTILE_APPROX` is a JavaScript function (UDF), and it is combining histograms to calculate the approximate percentile for each output row.  Sometimes, this work is too costly and BigQuery will run out of memory.

There are a few approaches to workaround this:

1. Utilize `WHERE` clauses to filter to a subset of the data (see [this example](/docs/samples/#page-load-time-by-country))
2. Issue a subquery against a high-cardinality dimension to break the dataset down first (see [this example](/docs/samples/#page-load-time-by-country-(using-a-subquery)))
3. Export the data and run your own queries or aggregation
