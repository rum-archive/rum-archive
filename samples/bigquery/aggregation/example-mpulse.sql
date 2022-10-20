WITH bucket_query AS (
    SELECT
        --
        -- Date
        --
        TO_VARCHAR(DATE_TRUNC('day', TO_TIMESTAMP_NTZ(timestamp, 3)), 'yyyy-mm-dd') AS date,

        --
        -- Dimensions
        --
        COALESCE(deviceTypeName, '') AS deviceType,
        COALESCE(userAgentName, '') AS userAgentFamily,
        COALESCE(userAgentVersion, '') AS userAgentVersion,
        TRIM(COALESCE(CONCAT(deviceManufacturerName, ' ', deviceName), '')) AS deviceModel,
        COALESCE(operatingSystemName, '') AS os,
        COALESCE(
            CASE
                WHEN operatingSystemVersion LIKE '%.%'
                    -- trim minor version
                    THEN left(operatingSystemVersion, charindex('.', operatingSystemVersion) - 1)
                ELSE operatingSystemVersion
            END
            , '') AS osVersion,
        REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
        COALESCE(countryCode, '') AS country,
        COALESCE(visibilityStateName, '') AS visibilityState,
        COALESCE(navigationTypeName, '') AS navigationType,
        COALESCE(httpProtocolName, '') AS protocol,
        COALESCE(ipVersionName, '') AS ipVersion,
        COALESCE(landingPageName, '') AS landingPage,

        --
        -- Timers and Metrics
        --
        CASE
            WHEN (pageLoadTime IS NULL OR pageLoadTime < 0) THEN NULL
            WHEN pageLoadTime = 0 THEN 0
            WHEN pageLoadTime <= 10000 THEN FLOOR(pageLoadTime / 100) + 1
            WHEN pageLoadTime <= 60000 THEN FLOOR((pageLoadTime - 10000) / 1000) + 101
            ELSE 151
        END AS pltBucket,
        CASE
            WHEN (pageLoadTime IS NULL OR pageLoadTime < 0) THEN NULL
            WHEN pageLoadTime > 60000 THEN 60000
            ELSE pageLoadTime
        END AS plt,

        CASE
            WHEN (dnsTimer IS NULL OR dnsTimer < 0) THEN NULL
            WHEN dnsTimer = 0 THEN 0
            WHEN dnsTimer <= 1000 THEN FLOOR(dnsTimer / 10) + 1
            WHEN dnsTimer <= 6000 THEN FLOOR((dnsTimer - 1000) / 100) + 101
            ELSE 151
        END AS dnsBucket,
        CASE
            WHEN (dnsTimer IS NULL OR dnsTimer < 0) THEN NULL
            WHEN dnsTimer > 6000 THEN 6000
            ELSE dnsTimer
        END AS dns,

        CASE
            WHEN (tcpTimer IS NULL OR tcpTimer < 0) THEN NULL
            WHEN tcpTimer = 0 THEN 0
            WHEN tcpTimer <= 1000 THEN FLOOR(tcpTimer / 10) + 1
            WHEN tcpTimer <= 6000 THEN FLOOR((tcpTimer - 1000) / 100) + 101
            ELSE 151
        END AS tcpBucket,
        CASE
            WHEN (tcpTimer IS NULL OR tcpTimer < 0) THEN NULL
            WHEN tcpTimer > 6000 THEN 6000
            ELSE tcpTimer
        END AS tcp,

        CASE
            WHEN (sslTimer IS NULL OR sslTimer < 0) THEN NULL
            WHEN sslTimer = 0 THEN 0
            WHEN sslTimer <= 1000 THEN FLOOR(sslTimer / 10) + 1
            WHEN sslTimer <= 6000 THEN FLOOR((sslTimer - 1000) / 100) + 101
            ELSE 151
        END AS tlsBucket,
        CASE
            WHEN (sslTimer IS NULL OR sslTimer < 0) THEN NULL
            WHEN sslTimer > 6000 THEN 6000
            ELSE sslTimer
        END AS tls,

        CASE
            WHEN (firstByteTimer IS NULL OR firstByteTimer < 0) THEN NULL
            WHEN firstByteTimer = 0 THEN 0
            WHEN firstByteTimer <= 1000 THEN FLOOR(firstByteTimer / 10) + 1
            WHEN firstByteTimer <= 6000 THEN FLOOR((firstByteTimer - 1000) / 100) + 101
            ELSE 151
        END AS ttfbBucket,
        CASE
            WHEN (firstByteTimer IS NULL OR firstByteTimer < 0) THEN NULL
            WHEN firstByteTimer > 6000 THEN 6000
            ELSE firstByteTimer
        END AS ttfb,

        CASE
            WHEN (firstContentfulPaint IS NULL OR firstContentfulPaint < 0) THEN NULL
            WHEN firstContentfulPaint = 0 THEN 0
            WHEN firstContentfulPaint <= 10000 THEN FLOOR(firstContentfulPaint / 100) + 1
            WHEN firstContentfulPaint <= 60000 THEN FLOOR((firstContentfulPaint - 10000) / 1000) + 101
            ELSE 151
        END AS fcpBucket,
        CASE
            WHEN (firstContentfulPaint IS NULL OR firstContentfulPaint < 0) THEN NULL
            WHEN firstContentfulPaint > 60000 THEN 60000
            ELSE firstContentfulPaint
        END AS fcp,

        CASE
            WHEN (largestContentfulPaint IS NULL OR largestContentfulPaint < 0) THEN NULL
            WHEN largestContentfulPaint = 0 THEN 0
            WHEN largestContentfulPaint <= 10000 THEN FLOOR(largestContentfulPaint / 100) + 1
            WHEN largestContentfulPaint <= 60000 THEN FLOOR((largestContentfulPaint - 10000) / 1000) + 101
            ELSE 151
        END AS lcpBucket,
        CASE
            WHEN (largestContentfulPaint IS NULL OR largestContentfulPaint < 0) THEN NULL
            WHEN largestContentfulPaint > 60000 THEN 60000
            ELSE largestContentfulPaint
        END AS lcp,

        CASE
            WHEN (paramsAkCr IS NULL OR paramsAkCr < 0) THEN NULL
            WHEN paramsAkCr = 0 THEN 0
            WHEN paramsAkCr <= 1000 THEN FLOOR(paramsAkCr / 10) + 1
            WHEN paramsAkCr <= 6000 THEN FLOOR((paramsAkCr - 1000) / 100) + 101
            ELSE 151
        END AS rttBucket,
        CASE
            WHEN (paramsAkCr IS NULL OR paramsAkCr < 0) THEN NULL
            WHEN paramsAkCr > 6000 THEN 6000
            ELSE paramsAkCr
        END AS rtt,

        CASE
            WHEN (rageClicks IS NULL OR rageClicks < 0) THEN NULL
            WHEN rageClicks = 0 THEN 0
            WHEN rageClicks <= 100 THEN rageClicks + 1
            WHEN rageClicks <= 600 THEN FLOOR((rageClicks - 100) / 10) + 101
            ELSE 151
        END AS rageClicksBucket,
        CASE
            WHEN (rageClicks IS NULL OR rageClicks < 0) THEN NULL
            WHEN rageClicks > 600 THEN 600
            ELSE rageClicks
        END AS rageClicks,

        CASE
            WHEN (cumulativeLayoutShift IS NULL OR cumulativeLayoutShift < 0) THEN NULL
            WHEN cumulativeLayoutShift = 0 THEN 0
            WHEN cumulativeLayoutShift <= 1000 THEN FLOOR(cumulativeLayoutShift / 10) + 1
            WHEN cumulativeLayoutShift <= 6000 THEN FLOOR((cumulativeLayoutShift - 1000) / 100) + 101
            ELSE 151
        END AS clsBucket,
        CASE
            WHEN (cumulativeLayoutShift IS NULL OR cumulativeLayoutShift < 0) THEN NULL
            WHEN cumulativeLayoutShift > 6000 THEN 6000
            ELSE cumulativeLayoutShift
        END AS cls,

        CASE
            WHEN (firstInputDelay IS NULL OR firstInputDelay < 0) THEN NULL
            WHEN firstInputDelay = 0 THEN 0
            WHEN firstInputDelay <= 1000 THEN FLOOR(firstInputDelay / 10) + 1
            WHEN firstInputDelay <= 6000 THEN FLOOR((firstInputDelay - 1000) / 100) + 101
            ELSE 151
        END AS fidBucket,
        CASE
            WHEN (firstInputDelay IS NULL OR firstInputDelay < 0) THEN NULL
            WHEN firstInputDelay > 6000 THEN 6000
            ELSE firstInputDelay
        END AS fid,

        CASE
            WHEN (interactionToNextPaint IS NULL OR interactionToNextPaint < 0) THEN NULL
            WHEN interactionToNextPaint = 0 THEN 0
            WHEN interactionToNextPaint <= 1000 THEN FLOOR(interactionToNextPaint / 10) + 1
            WHEN interactionToNextPaint <= 6000 THEN FLOOR((interactionToNextPaint - 1000) / 100) + 101
            ELSE 151
        END AS inpBucket,
        CASE
            WHEN (interactionToNextPaint IS NULL OR interactionToNextPaint < 0) THEN NULL
            WHEN interactionToNextPaint > 6000 THEN 6000
            ELSE interactionToNextPaint
        END AS inp,

        CASE
            WHEN (totalBlockingTime IS NULL OR totalBlockingTime < 0) THEN NULL
            WHEN totalBlockingTime = 0 THEN 0
            WHEN totalBlockingTime <= 10000 THEN FLOOR(totalBlockingTime / 100) + 1
            WHEN totalBlockingTime <= 60000 THEN FLOOR((totalBlockingTime - 10000) / 1000) + 101
            ELSE 151
        END AS tbtBucket,
        CASE
            WHEN (totalBlockingTime IS NULL OR totalBlockingTime < 0) THEN NULL
            WHEN totalBlockingTime > 60000 THEN 60000
            ELSE totalBlockingTime
        END AS tbt,

        CASE
            WHEN (tti IS NULL OR tti < 0) THEN NULL
            WHEN tti = 0 THEN 0
            WHEN tti <= 10000 THEN FLOOR(tti / 100) + 1
            WHEN tti <= 60000 THEN FLOOR((tti - 10000) / 1000) + 101
            ELSE 151
        END AS ttiBucket,
        CASE
            WHEN (tti IS NULL OR tti < 0) THEN NULL
            WHEN tti > 60000 THEN 60000
            ELSE tti
        END AS tti,

        CASE
            WHEN (redirectTime IS NULL OR redirectTime < 0) THEN NULL
            WHEN redirectTime = 0 THEN 0
            WHEN redirectTime <= 1000 THEN FLOOR(redirectTime / 10) + 1
            WHEN redirectTime <= 6000 THEN FLOOR((redirectTime - 1000) / 100) + 101
            ELSE 151
        END AS redirectBucket,
        CASE
            WHEN (redirectTime IS NULL OR redirectTime < 0) THEN NULL
            WHEN redirectTime > 6000 THEN 6000
            ELSE redirectTime
        END AS redirect

    --
    -- Tables
    --
    FROM %PAGE_LOADS_TABLE%

         -- apply some sort of sampling
         SAMPLE ROW (%BEACON_PCT%)

    --
    -- Clauses
    --

    -- exporting a day at a time
    WHERE TIMESTAMP BETWEEN DATE_PART('EPOCH_MILLISECOND', TO_TIMESTAMP('%DATE% 00:00:00.00 -0000'))
                        AND (DATE_PART('EPOCH_MILLISECOND', TO_TIMESTAMP('%DATE% 00:00:00.00 -0000')) + 86400000 - 1)

    -- only specific types of interactions
    AND beaconTypeName IN ('page view', 'spa_hard', 'spa')

    -- skip any rows that don't measure a Page Load Time
    AND pageLoadTime IS NOT NULL
    AND pageLoadTime > 0

    -- this query is run multiple times, one for each app exported in the dataset
    AND appid = %APP_ID%
)
SELECT  -- dimensions
        'mpulse' AS source,
        '(multiple)' AS site,
        plt.date,
        plt.deviceType,
        plt.userAgentFamily,
        plt.userAgentVersion,
        plt.deviceModel,
        plt.os,
        plt.osVersion,
        plt.beaconType,
        plt.country,
        plt.visibilityState,
        plt.navigationType,
        plt.protocol,
        plt.ipVersion,
        plt.landingPage,
        plt.beacons,

        -- timers and metrics
        to_json(plt.pltHistogram) AS pltHistogram,
        plt.pltAvg AS pltAvg,
        plt.pltSumLn AS pltSumLn,
        plt.pltBucketCount AS pltCount,
        to_json(dns.dnsHistogram) AS dnsHistogram,
        dns.dnsAvg AS dnsAvg,
        dns.dnsSumLn AS dnsSumLn,
        dns.dnsBucketCount AS dnsCount,
        to_json(tcp.tcpHistogram) AS tcpHistogram,
        tcp.tcpAvg AS tcpAvg,
        tcp.tcpSumLn AS tcpSumLn,
        tcp.tcpBucketCount AS tcpCount,
        to_json(tls.tlsHistogram) AS tlsHistogram,
        tls.tlsAvg AS tlsAvg,
        tls.tlsSumLn AS tlsSumLn,
        tls.tlsBucketCount AS tlsCount,
        to_json(ttfb.ttfbHistogram) AS ttfbHistogram,
        ttfb.ttfbAvg AS ttfbAvg,
        ttfb.ttfbSumLn AS ttfbSumLn,
        ttfb.ttfbBucketCount AS ttfbCount,
        to_json(fcp.fcpHistogram) AS fcpHistogram,
        fcp.fcpAvg AS fcpAvg,
        fcp.fcpSumLn AS fcpSumLn,
        fcp.fcpBucketCount AS fcpCount,
        to_json(lcp.lcpHistogram) AS lcpHistogram,
        lcp.lcpAvg AS lcpAvg,
        lcp.lcpSumLn AS lcpSumLn,
        lcp.lcpBucketCount AS lcpCount,
        to_json(rtt.rttHistogram) AS rttHistogram,
        rtt.rttAvg AS rttAvg,
        rtt.rttSumLn AS rttSumLn,
        rtt.rttBucketCount AS rttCount,
        to_json(rageClicks.rageClicksHistogram) AS rageClicksHistogram,
        rageClicks.rageClicksAvg AS rageClicksAvg,
        rageClicks.rageClicksSumLn AS rageClicksSumLn,
        rageClicks.rageClicksBucketCount AS rageClicksCount,
        to_json(cls.clsHistogram) AS clsHistogram,
        cls.clsAvg AS clsAvg,
        cls.clsSumLn AS clsSumLn,
        cls.clsBucketCount AS clsCount,
        to_json(fid.fidHistogram) AS fidHistogram,
        fid.fidAvg AS fidAvg,
        fid.fidSumLn AS fidSumLn,
        fid.fidBucketCount AS fidCount,
        to_json(tbt.tbtHistogram) AS tbtHistogram,
        tbt.tbtAvg AS tbtAvg,
        tbt.tbtSumLn AS tbtSumLn,
        tbt.tbtBucketCount AS tbtCount,
        to_json(tti.ttiHistogram) AS ttiHistogram,
        tti.ttiAvg AS ttiAvg,
        tti.ttiSumLn AS ttiSumLn,
        tti.ttiBucketCount AS ttiCount,
        to_json(redirect.redirectHistogram) AS redirectHistogram,
        redirect.redirectAvg AS redirectAvg,
        redirect.redirectSumLn AS redirectSumLn,
        redirect.redirectBucketCount AS redirectCount,
        to_json(inp.inpHistogram) AS inpHistogram,
        inp.inpAvg AS inpAvg,
        inp.inpSumLn AS inpSumLn,
        inp.inpBucketCount AS inpCount
FROM
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        pltBucket::VARCHAR,
        ARRAY_CONSTRUCT(pltBucketMid, pltBucketCount)
        ) AS pltHistogram,
        AVG(pltAvg) AS pltAvg,
        SUM(pltSumLn) AS pltSumLn,
        SUM(pltBucketCount) AS pltBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            pltBucket,
            ROUND(MEDIAN(plt)) AS pltBucketMid,
            COUNT(plt) AS pltBucketCount,
            AVG(plt) AS pltAvg,
            SUM(LN(GREATEST(plt, 0.000001))) AS pltSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            pltBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) plt
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        dnsBucket::VARCHAR,
        ARRAY_CONSTRUCT(dnsBucketMid, dnsBucketCount)
        ) AS dnsHistogram,
        AVG(dnsAvg) AS dnsAvg,
        SUM(dnsSumLn) AS dnsSumLn,
        SUM(dnsBucketCount) AS dnsBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            dnsBucket,
            ROUND(MEDIAN(dns)) AS dnsBucketMid,
            COUNT(dns) AS dnsBucketCount,
            AVG(dns) AS dnsAvg,
            SUM(LN(GREATEST(dns, 0.000001))) AS dnsSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            dnsBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) dns
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        tcpBucket::VARCHAR,
        ARRAY_CONSTRUCT(tcpBucketMid, tcpBucketCount)
        ) AS tcpHistogram,
        AVG(tcpAvg) AS tcpAvg,
        SUM(tcpSumLn) AS tcpSumLn,
        SUM(tcpBucketCount) AS tcpBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            tcpBucket,
            ROUND(MEDIAN(tcp)) AS tcpBucketMid,
            COUNT(tcp) AS tcpBucketCount,
            AVG(tcp) AS tcpAvg,
            SUM(LN(GREATEST(tcp, 0.000001))) AS tcpSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            tcpBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) tcp
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        tlsBucket::VARCHAR,
        ARRAY_CONSTRUCT(tlsBucketMid, tlsBucketCount)
        ) AS tlsHistogram,
        AVG(tlsAvg) AS tlsAvg,
        SUM(tlsSumLn) AS tlsSumLn,
        SUM(tlsBucketCount) AS tlsBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            tlsBucket,
            ROUND(MEDIAN(tls)) AS tlsBucketMid,
            COUNT(tls) AS tlsBucketCount,
            AVG(tls) AS tlsAvg,
            SUM(LN(GREATEST(tls, 0.000001))) AS tlsSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            tlsBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) tls
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        ttfbBucket::VARCHAR,
        ARRAY_CONSTRUCT(ttfbBucketMid, ttfbBucketCount)
        ) AS ttfbHistogram,
        AVG(ttfbAvg) AS ttfbAvg,
        SUM(ttfbSumLn) AS ttfbSumLn,
        SUM(ttfbBucketCount) AS ttfbBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            ttfbBucket,
            ROUND(MEDIAN(ttfb)) AS ttfbBucketMid,
            COUNT(ttfb) AS ttfbBucketCount,
            AVG(ttfb) AS ttfbAvg,
            SUM(LN(GREATEST(ttfb, 0.000001))) AS ttfbSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            ttfbBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) ttfb
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        fcpBucket::VARCHAR,
        ARRAY_CONSTRUCT(fcpBucketMid, fcpBucketCount)
        ) AS fcpHistogram,
        AVG(fcpAvg) AS fcpAvg,
        SUM(fcpSumLn) AS fcpSumLn,
        SUM(fcpBucketCount) AS fcpBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            fcpBucket,
            ROUND(MEDIAN(fcp)) AS fcpBucketMid,
            COUNT(fcp) AS fcpBucketCount,
            AVG(fcp) AS fcpAvg,
            SUM(LN(GREATEST(fcp, 0.000001))) AS fcpSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            fcpBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) fcp
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        lcpBucket::VARCHAR,
        ARRAY_CONSTRUCT(lcpBucketMid, lcpBucketCount)
        ) AS lcpHistogram,
        AVG(lcpAvg) AS lcpAvg,
        SUM(lcpSumLn) AS lcpSumLn,
        SUM(lcpBucketCount) AS lcpBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            lcpBucket,
            ROUND(MEDIAN(lcp)) AS lcpBucketMid,
            COUNT(lcp) AS lcpBucketCount,
            AVG(lcp) AS lcpAvg,
            SUM(LN(GREATEST(lcp, 0.000001))) AS lcpSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            lcpBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) lcp
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        rttBucket::VARCHAR,
        ARRAY_CONSTRUCT(rttBucketMid, rttBucketCount)
        ) AS rttHistogram,
        AVG(rttAvg) AS rttAvg,
        SUM(rttSumLn) AS rttSumLn,
        SUM(rttBucketCount) AS rttBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            rttBucket,
            ROUND(MEDIAN(rtt)) AS rttBucketMid,
            COUNT(rtt) AS rttBucketCount,
            AVG(rtt) AS rttAvg,
            SUM(LN(GREATEST(rtt, 0.000001))) AS rttSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            rttBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) rtt
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        rageClicksBucket::VARCHAR,
        ARRAY_CONSTRUCT(rageClicksBucketMid, rageClicksBucketCount)
        ) AS rageClicksHistogram,
        AVG(rageClicksAvg) AS rageClicksAvg,
        SUM(rageClicksSumLn) AS rageClicksSumLn,
        SUM(rageClicksBucketCount) AS rageClicksBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            rageClicksBucket,
            ROUND(MEDIAN(rageClicks)) AS rageClicksBucketMid,
            COUNT(rageClicks) AS rageClicksBucketCount,
            AVG(rageClicks) AS rageClicksAvg,
            SUM(LN(GREATEST(rageClicks, 0.000001))) AS rageClicksSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            rageClicksBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) rageClicks
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        clsBucket::VARCHAR,
        ARRAY_CONSTRUCT(clsBucketMid, clsBucketCount)
        ) AS clsHistogram,
        AVG(clsAvg) AS clsAvg,
        SUM(clsSumLn) AS clsSumLn,
        SUM(clsBucketCount) AS clsBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            clsBucket,
            ROUND(MEDIAN(cls)) AS clsBucketMid,
            COUNT(cls) AS clsBucketCount,
            AVG(cls) AS clsAvg,
            SUM(LN(GREATEST(cls, 0.000001))) AS clsSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            clsBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) cls
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        fidBucket::VARCHAR,
        ARRAY_CONSTRUCT(fidBucketMid, fidBucketCount)
        ) AS fidHistogram,
        AVG(fidAvg) AS fidAvg,
        SUM(fidSumLn) AS fidSumLn,
        SUM(fidBucketCount) AS fidBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            fidBucket,
            ROUND(MEDIAN(fid)) AS fidBucketMid,
            COUNT(fid) AS fidBucketCount,
            AVG(fid) AS fidAvg,
            SUM(LN(GREATEST(fid, 0.000001))) AS fidSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            fidBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) fid
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        tbtBucket::VARCHAR,
        ARRAY_CONSTRUCT(tbtBucketMid, tbtBucketCount)
        ) AS tbtHistogram,
        AVG(tbtAvg) AS tbtAvg,
        SUM(tbtSumLn) AS tbtSumLn,
        SUM(tbtBucketCount) AS tbtBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            tbtBucket,
            ROUND(MEDIAN(tbt)) AS tbtBucketMid,
            COUNT(tbt) AS tbtBucketCount,
            AVG(tbt) AS tbtAvg,
            SUM(LN(GREATEST(tbt, 0.000001))) AS tbtSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            tbtBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) tbt
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        ttiBucket::VARCHAR,
        ARRAY_CONSTRUCT(ttiBucketMid, ttiBucketCount)
        ) AS ttiHistogram,
        AVG(ttiAvg) AS ttiAvg,
        SUM(ttiSumLn) AS ttiSumLn,
        SUM(ttiBucketCount) AS ttiBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            ttiBucket,
            ROUND(MEDIAN(tti)) AS ttiBucketMid,
            COUNT(tti) AS ttiBucketCount,
            AVG(tti) AS ttiAvg,
            SUM(LN(GREATEST(tti, 0.000001))) AS ttiSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            ttiBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) tti
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
INNER JOIN
(
    SELECT
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage,
        SUM(beacons) AS beacons,
        OBJECT_AGG(DISTINCT
        redirectBucket::VARCHAR,
        ARRAY_CONSTRUCT(redirectBucketMid, redirectBucketCount)
        ) AS redirectHistogram,
        AVG(redirectAvg) AS redirectAvg,
        SUM(redirectSumLn) AS redirectSumLn,
        SUM(redirectBucketCount) AS redirectBucketCount
    FROM (
        SELECT
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            count(*) AS beacons,
            redirectBucket,
            ROUND(MEDIAN(redirect)) AS redirectBucketMid,
            COUNT(redirect) AS redirectBucketCount,
            AVG(redirect) AS redirectAvg,
            SUM(LN(GREATEST(redirect, 0.000001))) AS redirectSumLn
        FROM bucket_query
        GROUP BY
            date,
            deviceType,
            userAgentFamily,
            userAgentVersion,
            deviceModel,
            os,
            osVersion,
            beaconType,
            country,
            visibilityState,
            navigationType,
            protocol,
            ipVersion,
            landingPage,
            redirectBucket
        )
    GROUP BY
        date,
        deviceType,
        userAgentFamily,
        userAgentVersion,
        deviceModel,
        os,
        osVersion,
        beaconType,
        country,
        visibilityState,
        navigationType,
        protocol,
        ipVersion,
        landingPage
    ) redirect
USING (
    date,
    deviceType,
    userAgentFamily,
    userAgentVersion,
    deviceModel,
    os,
    osVersion,
    beaconType,
    country,
    visibilityState,
    navigationType,
    protocol,
    ipVersion,
    landingPage
)
WHERE beacons >= %MIN_BEACON_COUNT%
