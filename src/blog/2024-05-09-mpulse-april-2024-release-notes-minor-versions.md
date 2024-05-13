---
title: mPulse RUM data now includes minor versions for Safari and iOS
date: 2024-05-09
description: mPulse daily RUM data through April 2024 has been loaded, and now now includes minor versions for Safari / iOS
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /assets/rum-archive-logo.svg
---

## Latest mPulse RUM Data Loaded

We've completed an export of mPulse daily RUM data into the BigQuery [`akamai-mpulse-rumarchive`](/datasets/#akamai-mpulse-rum) project up through 2024-04-30.

This brings the RUM Archive's [mPulse dataset](/datasets/#akamai-mpulse-rum) to a running total of 617 straight days of data available since 2022-09-01.  (There is also first-of-month data going back to 2021-10-01).

## Minor Versions for Safarai, iOS

From 2024-04-01 onward, the [`USERAGENTVERSION`](/docs/tables/#dimensions) and [`OSVERSION`](/docs/tables/#dimensions) columns now contain the _Minor_ version information for a subset of browsers and operating systems.  For example, you'll see rows with user agent version of `17.5` for Safari instead of just `17`.

Both the mPulse Page Load and Third-Party Resource tables now include minor version numbers for the following browsers:

* `Safari`
* `Mobile Safari`
* `Mobile Safari UI/WKWebView`
  
In addition, the mPulse Page Load and Third-Party Resource tables now include minor version numbers for the following operating systems:

* `iOS`
* `iPadOS`

All other browsers and operating systems will continue to only contain the major version.

For most browsers and OSs, the major version generally conveys the important features that are included in that release.  For example, NavigationTiming has been available since [Chrome 6+](https://caniuse.com/nav-timing), and [ResourceTiming since 25+](https://caniuse.com/resource-timing).

On the other hand, Safari releases _minor_ versions (e.g. `17.1`, `17.2`, `17.3`, `17.4`) at roughly the same schedule that the other browsers release _major_ versions (e.g. Chrome `120`, `122`, `124`).  As a result, Safari and iOS often [add major features](https://developer.apple.com/documentation/safari-release-notes) in those "minor" version releases.

There has been a [Github issue request](https://github.com/rum-archive/rum-archive/issues/16) to track minor versions of Safari in the RUM Archive for a while.  For now, we've decided to do this only for Safari and iOS (per the above list).   We are not including minor versions for other browsers and operating systems for two reasons:

* To _minimize_ problems for queries that span both pre-2024-04 and post-2024-04 data (see below for how to deal with this)
* Each increase in dimension cardinality creates the possibility that some data may not be included in the RUM Archive dataset due to our [minimum count threshold requirements](/docs/methodology/#minimum-count-threshold) (e.g. more outliers could be excluded)

### How to Query Minor Versions

`USERAGENTVERSION` and `OSVERSION` are the only two columns affected.

If you query data prior to 2024-04-1, all versions should only contain a single number (major version):

```sql
-- 2024-03-31
SELECT  USERAGENTFAMILY,
        USERAGENTVERSION,
        SUM(BEACONS) as BEACONCOUNT,
        ROUND(SUM(BEACONS) /
          (SELECT SUM(BEACONS)
            FROM `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
            WHERE DATE = '2024-03-31' AND USERAGENTFAMILY = 'Mobile Safari')
          * 100, 1) as BEACONCOUNTPCT,
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2024-03-31"
    AND USERAGENTFAMILY = 'Mobile Safari'
GROUP BY USERAGENTFAMILY, USERAGENTVERSION
ORDER BY BEACONCOUNT DESC
LIMIT 10
```

| USERAGENTFAMILY | USERAGENTVERSION | BEACONCOUNT | BEACONCOUNTPCT |
|-----------------|-----------------:|------------:|---------------:|
| Mobile Safari   |               17 |    30735863 |           78.0 |
| Mobile Safari   |               16 |     6617861 |           16.8 |
| Mobile Safari   |               15 |     1437859 |            3.7 |
| Mobile Safari   |               13 |      310754 |            0.8 |
| Mobile Safari   |               14 |      208382 |            0.5 |
| Mobile Safari   |               12 |       53219 |            0.1 |
| Mobile Safari   |               10 |        8930 |            0.0 |
| Mobile Safari   |               11 |        8499 |            0.0 |
| Mobile Safari   |                  |        3048 |            0.0 |
| Mobile Safari   |                6 |        2374 |            0.0 |

Starting with 2024-04-01 onward, the same columns will have `Major.Minor` versions for the listed browsers and OSs:

```sql
-- 2024-04-01
SELECT  USERAGENTFAMILY,
        USERAGENTVERSION,
        SUM(BEACONS) as BEACONCOUNT,
        ROUND(SUM(BEACONS) /
          (SELECT SUM(BEACONS)
            FROM `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
            WHERE DATE = '2024-04-01' AND USERAGENTFAMILY = 'Mobile Safari')
          * 100, 1) as BEACONCOUNTPCT,
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   DATE = "2024-04-01"
    AND USERAGENTFAMILY = 'Mobile Safari'
GROUP BY USERAGENTFAMILY, USERAGENTVERSION
ORDER BY BEACONCOUNT DESC
LIMIT 10
```

| USERAGENTFAMILY | USERAGENTVERSION | BEACONCOUNT | BEACONCOUNTPCT |
|-----------------|-----------------:|------------:|---------------:|
| Mobile Safari   |             17.3 |    27200470 |           59.5 |
| Mobile Safari   |             17.4 |     5658521 |           12.4 |
| Mobile Safari   |             16.6 |     3591843 |            7.9 |
| Mobile Safari   |             17.2 |     1478059 |            3.2 |
| Mobile Safari   |             16.1 |     1376605 |            3.0 |
| Mobile Safari   |             15.6 |     1213163 |            2.7 |
| Mobile Safari   |             16.3 |     1130011 |            2.5 |
| Mobile Safari   |             17.1 |     1007907 |            2.2 |
| Mobile Safari   |             16.2 |      643075 |            1.4 |
| Mobile Safari   |             16.0 |      523994 |            1.1 |

If your queries span before/after 2024-04-01, you may want to remove the minor version from `USERAGENTVERSION` and `OSVERSION`.  Otherwise, you will see a mixture of dimension with-and-without the `.`.

For example, this query spans 2024-03-31 and 2024-04-01, but does not "deal with" the change to include minor versions:

```sql
-- data spanning dates before and after the minor versions were added
SELECT  USERAGENTFAMILY,
        SPLIT(USERAGENTVERSION, '.')[OFFSET(0)] AS USERAGENTVERSION,
        SUM(BEACONS) as BEACONCOUNT,
        ROUND(SUM(BEACONS) /
          (SELECT SUM(BEACONS)
            FROM `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
            WHERE (DATE = '2024-03-31' OR DATE = '2024-04-01') AND USERAGENTFAMILY = 'Mobile Safari')
          * 100, 1) as BEACONCOUNTPCT,
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   (DATE = '2024-03-31' OR DATE = '2024-04-01')
    AND USERAGENTFAMILY = 'Mobile Safari'
GROUP BY USERAGENTFAMILY, USERAGENTVERSION
ORDER BY BEACONCOUNT DESC
```

And as a result, the `USERAGENTVERSION` has data for `17` but also for `17.0`, `17.1`, `17.2`, etc:

| USERAGENTFAMILY | USERAGENTVERSION | BEACONCOUNT | BEACONCOUNTPCT |
|-----------------|-----------------:|------------:|---------------:|
| Mobile Safari   |               17 |    30735863 |           36.1 |
| Mobile Safari   |             17.3 |    27200470 |           32.0 |
| Mobile Safari   |               16 |     6617861 |            7.8 |
| Mobile Safari   |             17.4 |     5658521 |            6.6 |
| Mobile Safari   |             16.6 |     3591843 |            4.2 |
| Mobile Safari   |             17.2 |     1478059 |            1.7 |
| Mobile Safari   |               15 |     1437859 |            1.7 |
| Mobile Safari   |             16.1 |     1376605 |            1.6 |
| Mobile Safari   |             15.6 |     1213163 |            1.4 |
| Mobile Safari   |             16.3 |     1130011 |            1.3 |
| Mobile Safari   |             17.1 |     1007907 |            1.2 |
| Mobile Safari   |             16.2 |      643075 |            0.8 |
| Mobile Safari   |             16.0 |      523994 |            0.6 |
| Mobile Safari   |             13.0 |      373017 |            0.4 |
| Mobile Safari   |             16.5 |      321928 |            0.4 |
| Mobile Safari   |               13 |      310754 |            0.4 |
| Mobile Safari   |             17.0 |      296167 |            0.3 |

Instead, you can use simple SQL like `SPLIT()` to re-combine minor versions into the major version:

```sql
-- re-combine minor versions into just the major version
SELECT  USERAGENTFAMILY,
        SPLIT(USERAGENTVERSION, '.')[OFFSET(0)] AS USERAGENTVERSION,
        SUM(BEACONS) as BEACONCOUNT,
        ROUND(SUM(BEACONS) /
          (SELECT SUM(BEACONS)
            FROM `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
            WHERE (DATE = '2024-03-31' OR DATE = '2024-04-01') AND USERAGENTFAMILY = 'Mobile Safari')
          * 100, 1) as BEACONCOUNTPCT,
FROM    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE   (DATE = '2024-03-31' OR DATE = '2024-04-01')
    AND USERAGENTFAMILY = 'Mobile Safari'
GROUP BY USERAGENTFAMILY, USERAGENTVERSION
ORDER BY BEACONCOUNT DESC
```

And then the data is re-combined:

| USERAGENTFAMILY | USERAGENTVERSION | BEACONCOUNT | BEACONCOUNTPCT |
|-----------------|-----------------:|------------:|---------------:|
| Mobile Safari   |               17 |    66377696 |           78.0 |
| Mobile Safari   |               16 |    14328819 |           16.8 |
| Mobile Safari   |               15 |     3088770 |            3.6 |
| Mobile Safari   |               13 |      698902 |            0.8 |
| Mobile Safari   |               14 |      431060 |            0.5 |
| Mobile Safari   |               12 |      122833 |            0.1 |
| Mobile Safari   |               10 |       22016 |            0.0 |
| Mobile Safari   |               11 |       17783 |            0.0 |

If you have any questions or feedback, please let us know!