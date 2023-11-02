---
title: mPulse RUM Data Loaded through February 2023 + Rage Clicks Breaking Change
date: 2023-03-16
description: mPulse daily RUM data for January and February 2023 has been loaded, along with a breaking change to the Rage Clicks column.
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /blog/2023-03-16-mpulse-january-data-rage-clicks-change.png
---

## Latest mPulse RUM Data Loaded

We've completed an export of mPulse daily RUM data into the BigQuery [`akamai-mpulse-rumarchive`](/datasets/#akamai-mpulse-rum) project up through 2023-02-28.

This brings the RUM Archive's [mPulse dataset](/datasets/#akamai-mpulse-rum) to a running total of 180 straight days of data available since 2022-09-01.  (There is also first-of-month data going back to 2021-10-01).

We have plans to automate this process so that the mPulse RUM data is added on a weekly or daily cadence, but it is currently a manual process that we do at the end of each month.  We are currently able to release each new month's data within a few days of the end of the month.

## Breaking Change to `rageClicksHistogram`

Starting with the RUM Archive's mPulse dataset from 2023-01-01, there is a _breaking change_ to the `rageClicksHistogram` column.

For mPulse RUM data from 2021-10-01 through 2022-12-31, the column `rageClicksHistogram` had histogram bucket numbers off-by-one from what was intended.

For review, all of the other [Timers'](/docs/tables/) [histograms](/docs/methodology/#histogram-format) like PLT, DNS, etc are:

* Bucket 0 should contain values where that timer was 0
* Bucket 1 should contain values for the first high-precision bucket (e.g. 1-100ms for PLT)
* Bucket 2-100 should contain the rest of the high-precision values
* Buckets 101-150 should contain the low-precision values
* Bucket 151 is any data outside of the low-precision range

However for Rage Clicks, which is the only "metric" (a count) we've exported so far, we had mistakenly exported the buckets as follows (until 2022-12-31):

* Bucket 0 if Rage Clicks were zero (which we skip)
* Bucket 1 is unused
* Bucket 2-100 is if Rage Click count is 1-99
* Bucket 101-150 is Rage Click Count 100-600
* Bucket 151 is >600

This bucket mapping is a bug we've fixed: Bucket 1 is essentially unused.  We should have just used buckets 1-100 for Rage Click counts of 1-100 to simplify things, instead of Buckets 2-100 mapping to clicks of 1-99.

We've made a change to the data exported to the `rageClicksHistogram` column in the `akamai-mpulse-rumarchive` project starting `2023-01-0`.  Buckets 1-100 now reflect data for Rage Clicks of values 1-100.
