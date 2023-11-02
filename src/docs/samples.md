---
title: Sample Queries
description: Sample RUM Archive queries.
layout: layouts/page.njk
tags: docs
order: 3
---

### Intro

Here are some sample [queries](/docs/querying) to get you started.

All of these queries can be run against the [Akamai mPulse RUM dataset](/datasets).

**NOTE**: It is recommended you [always use a `DATE` filter](/docs/tips/#limiting-bigquery-costs) to minimize query size and cost.

### Unique Dimension Values

To understand the unique values available for each dimension, you can run a `DISTINCT` query:

```sql
SELECT  DISTINCT DEVICEMODEL
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = '2022-09-01'
ORDER BY DEVICEMODEL ASC
```

### Dimension Popularity

You can calculate the frequency of [Dimension](/docs/tables#dimensions) values by doing a `GROUP BY` and calculating the `SUM(BEACONS)` count for that date.

Ensure you're not just calculating row `COUNT(*)` for each group, as each row is weighted differently (by `BEACONS` count).

For example, this shows the counts of each Device Type in the mPulse dataset for 2022-09-01.

(**NOTE**: [Data is sampled](/docs/tips/#data-is-sampled) so these [counts should only be used for relative percentages](/docs/tips/#counts-should-only-be-used-for-relative-percentages)).

```sql
SELECT  DEVICETYPE,
        SUM(BEACONS) AS BEACONCOUNT
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = '2022-09-01'
GROUP BY DEVICETYPE
ORDER BY BEACONCOUNT DESC
```

### Dimension Popularity (as a percentage of total)

You can calculate the _relative_ popularity of [Dimension](/docs/tables#dimensions) values by doing a `GROUP BY` and calculating the `SUM(BEACONS)` count for that date, compared to the overall `SUM(BEACONS)` for all rows.

For example, this shows the relative popularity of Device Types in the mPulse dataset for 2022-09-01:

```sql
SELECT  DEVICETYPE,
        SUM(BEACONS) AS BEACONCOUNT,
        (
          SUM(BEACONS) /
            (SELECT SUM(BEACONS)
             FROM `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
             WHERE DATE = '2022-09-01')
        ) AS BEACONPCT
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = '2022-09-01'
GROUP BY DEVICETYPE
ORDER BY BEACONCOUNT DESC
```

### Page Load Time by Country

Using the [`PERCENTILE_APPROX`](docs/querying/#approximate-percentiles) function, you can calculate the approximate percentile (e.g. median) for a set of data.

**NOTE**: When using the [`PERCENTILE_APPROX`](docs/querying/#approximate-percentiles) function, it may run out of memory when run in BigQuery.  It will often do this if you're executing a query over all of the data for one day (e.g. no filters have been applied).

The work around is shown below, to limit the dataset via `WHERE` filters, or the following sample which uses a subquery to reduce memory pressure.

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

### Page Load Time by Country (using a Subquery)

Using the [`PERCENTILE_APPROX`](docs/querying/#approximate-percentiles) function, you can calculate the approximate percentile (e.g. median) for a set of data.

If you are querying an entire day's worth of data, the [`PERCENTILE_APPROX`](docs/querying/#approximate-percentiles) may run out of memory in BigQuery.

One workaround is to pre-aggregate the data further by using the [`COMBINE_HISTOGRAMS`](docs/querying/#combined-histograms) function against a column with high cardinality (e.g. `COUNTRY` or `DEVICEMODEL`), before issuing the final query against the dimensions you care about.

```sql
SELECT  PROTOCOL,
        SUM(BEACONS) AS BEACONS,
        `akamai-mpulse-rumarchive.rumarchive.PERCENTILE_APPROX`(
          ARRAY_AGG(PLTHISTOGRAM),
          [0.0, 0.25, 0.50, 0.75, 0.90, 0.95, 1.0],
          100,
          false) AS PERCENTILES
FROM    (
    SELECT  COUNTRY,
            PROTOCOL,
            SUM(BEACONS) AS BEACONS,
            `akamai-mpulse-rumarchive.rumarchive.COMBINE_HISTOGRAMS`(ARRAY_AGG(PLTHISTOGRAM)) AS PLTHISTOGRAM
    FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
    WHERE   DATE = '2022-09-01'
    GROUP BY COUNTRY, PROTOCOL
) AS subquery
GROUP BY PROTOCOL
ORDER BY COUNT(*) DESC
```
