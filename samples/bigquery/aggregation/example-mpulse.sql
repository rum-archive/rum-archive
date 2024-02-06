SELECT  -- dimensions
        'mpulse' AS source,
        '(multiple)' AS site,
        '{{DATE}}' AS date,
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

        -- timers
        plt.pltHistogram AS pltHistogram,
        plt.pltAvg AS pltAvg,
        plt.pltSumLn AS pltSumLn,
        plt.pltBucketCount AS pltCount,
        CASE WHEN dns.dnsHistogram IS NULL THEN '{}' ELSE dns.dnsHistogram END AS dnsHistogram,
        CASE WHEN dns.dnsAvg IS NULL THEN '' ELSE dns.dnsAvg END AS dnsAvg,
        CASE WHEN dns.dnsSumLn IS NULL THEN '' ELSE dns.dnsSumLn END AS dnsSumLn,
        CASE WHEN dns.dnsBucketCount IS NULL THEN 0 ELSE dns.dnsBucketCount END AS dnsCount,
        CASE WHEN tcp.tcpHistogram IS NULL THEN '{}' ELSE tcp.tcpHistogram END AS tcpHistogram,
        CASE WHEN tcp.tcpAvg IS NULL THEN '' ELSE tcp.tcpAvg END AS tcpAvg,
        CASE WHEN tcp.tcpSumLn IS NULL THEN '' ELSE tcp.tcpSumLn END AS tcpSumLn,
        CASE WHEN tcp.tcpBucketCount IS NULL THEN 0 ELSE tcp.tcpBucketCount END AS tcpCount,
        CASE WHEN tls.tlsHistogram IS NULL THEN '{}' ELSE tls.tlsHistogram END AS tlsHistogram,
        CASE WHEN tls.tlsAvg IS NULL THEN '' ELSE tls.tlsAvg END AS tlsAvg,
        CASE WHEN tls.tlsSumLn IS NULL THEN '' ELSE tls.tlsSumLn END AS tlsSumLn,
        CASE WHEN tls.tlsBucketCount IS NULL THEN 0 ELSE tls.tlsBucketCount END AS tlsCount,
        CASE WHEN ttfb.ttfbHistogram IS NULL THEN '{}' ELSE ttfb.ttfbHistogram END AS ttfbHistogram,
        CASE WHEN ttfb.ttfbAvg IS NULL THEN '' ELSE ttfb.ttfbAvg END AS ttfbAvg,
        CASE WHEN ttfb.ttfbSumLn IS NULL THEN '' ELSE ttfb.ttfbSumLn END AS ttfbSumLn,
        CASE WHEN ttfb.ttfbBucketCount IS NULL THEN 0 ELSE ttfb.ttfbBucketCount END AS ttfbCount,
        CASE WHEN fcp.fcpHistogram IS NULL THEN '{}' ELSE fcp.fcpHistogram END AS fcpHistogram,
        CASE WHEN fcp.fcpAvg IS NULL THEN '' ELSE fcp.fcpAvg END AS fcpAvg,
        CASE WHEN fcp.fcpSumLn IS NULL THEN '' ELSE fcp.fcpSumLn END AS fcpSumLn,
        CASE WHEN fcp.fcpBucketCount IS NULL THEN 0 ELSE fcp.fcpBucketCount END AS fcpCount,
        CASE WHEN lcp.lcpHistogram IS NULL THEN '{}' ELSE lcp.lcpHistogram END AS lcpHistogram,
        CASE WHEN lcp.lcpAvg IS NULL THEN '' ELSE lcp.lcpAvg END AS lcpAvg,
        CASE WHEN lcp.lcpSumLn IS NULL THEN '' ELSE lcp.lcpSumLn END AS lcpSumLn,
        CASE WHEN lcp.lcpBucketCount IS NULL THEN 0 ELSE lcp.lcpBucketCount END AS lcpCount,
        CASE WHEN rtt.rttHistogram IS NULL THEN '{}' ELSE rtt.rttHistogram END AS rttHistogram,
        CASE WHEN rtt.rttAvg IS NULL THEN '' ELSE rtt.rttAvg END AS rttAvg,
        CASE WHEN rtt.rttSumLn IS NULL THEN '' ELSE rtt.rttSumLn END AS rttSumLn,
        CASE WHEN rtt.rttBucketCount IS NULL THEN 0 ELSE rtt.rttBucketCount END AS rttCount,
        CASE WHEN rageClicks.rageClicksHistogram IS NULL THEN '{}' ELSE rageClicks.rageClicksHistogram END AS rageClicksHistogram,
        CASE WHEN rageClicks.rageClicksAvg IS NULL THEN '' ELSE rageClicks.rageClicksAvg END AS rageClicksAvg,
        CASE WHEN rageClicks.rageClicksSumLn IS NULL THEN '' ELSE rageClicks.rageClicksSumLn END AS rageClicksSumLn,
        CASE WHEN rageClicks.rageClicksBucketCount IS NULL THEN 0 ELSE rageClicks.rageClicksBucketCount END AS rageClicksCount,
        CASE WHEN cls.clsHistogram IS NULL THEN '{}' ELSE cls.clsHistogram END AS clsHistogram,
        CASE WHEN cls.clsAvg IS NULL THEN '' ELSE cls.clsAvg END AS clsAvg,
        CASE WHEN cls.clsSumLn IS NULL THEN '' ELSE cls.clsSumLn END AS clsSumLn,
        CASE WHEN cls.clsBucketCount IS NULL THEN 0 ELSE cls.clsBucketCount END AS clsCount,
        CASE WHEN fid.fidHistogram IS NULL THEN '{}' ELSE fid.fidHistogram END AS fidHistogram,
        CASE WHEN fid.fidAvg IS NULL THEN '' ELSE fid.fidAvg END AS fidAvg,
        CASE WHEN fid.fidSumLn IS NULL THEN '' ELSE fid.fidSumLn END AS fidSumLn,
        CASE WHEN fid.fidBucketCount IS NULL THEN 0 ELSE fid.fidBucketCount END AS fidCount,
        CASE WHEN tbt.tbtHistogram IS NULL THEN '{}' ELSE tbt.tbtHistogram END AS tbtHistogram,
        CASE WHEN tbt.tbtAvg IS NULL THEN '' ELSE tbt.tbtAvg END AS tbtAvg,
        CASE WHEN tbt.tbtSumLn IS NULL THEN '' ELSE tbt.tbtSumLn END AS tbtSumLn,
        CASE WHEN tbt.tbtBucketCount IS NULL THEN 0 ELSE tbt.tbtBucketCount END AS tbtCount,
        CASE WHEN tti.ttiHistogram IS NULL THEN '{}' ELSE tti.ttiHistogram END AS ttiHistogram,
        CASE WHEN tti.ttiAvg IS NULL THEN '' ELSE tti.ttiAvg END AS ttiAvg,
        CASE WHEN tti.ttiSumLn IS NULL THEN '' ELSE tti.ttiSumLn END AS ttiSumLn,
        CASE WHEN tti.ttiBucketCount IS NULL THEN 0 ELSE tti.ttiBucketCount END AS ttiCount,
        CASE WHEN redirect.redirectHistogram IS NULL THEN '{}' ELSE redirect.redirectHistogram END AS redirectHistogram,
        CASE WHEN redirect.redirectAvg IS NULL THEN '' ELSE redirect.redirectAvg END AS redirectAvg,
        CASE WHEN redirect.redirectSumLn IS NULL THEN '' ELSE redirect.redirectSumLn END AS redirectSumLn,
        CASE WHEN redirect.redirectBucketCount IS NULL THEN 0 ELSE redirect.redirectBucketCount END AS redirectCount,
        CASE WHEN inp.inpHistogram IS NULL THEN '{}' ELSE inp.inpHistogram END AS inpHistogram,
        CASE WHEN inp.inpAvg IS NULL THEN '' ELSE inp.inpAvg END AS inpAvg,
        CASE WHEN inp.inpSumLn IS NULL THEN '' ELSE inp.inpSumLn END AS inpSumLn,
        CASE WHEN inp.inpBucketCount IS NULL THEN 0 ELSE inp.inpBucketCount END AS inpCount
FROM
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(pltBucket, pltBucketMidCount)))) AS pltHistogram,
        SUM(pltAvg * pltBucketCount) / SUM(pltBucketCount) AS pltAvg,
        SUM(pltSumLn) AS pltSumLn,
        SUM(pltBucketCount) AS pltBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            pltBucket,
            ARRAY(CAST(ROUND(PERCENTILE(plt, 0.5)) AS INT), COUNT(plt)) AS pltBucketMidCount,
            COUNT(plt) AS pltBucketCount,
            AVG(plt) AS pltAvg,
            SUM(LN(GREATEST(plt, 0.000001))) AS pltSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
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
                END AS plt
            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE pltBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(dnsBucket, dnsBucketMidCount)))) AS dnsHistogram,
        SUM(dnsAvg * dnsBucketCount) / SUM(dnsBucketCount) AS dnsAvg,
        SUM(dnsSumLn) AS dnsSumLn,
        SUM(dnsBucketCount) AS dnsBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            dnsBucket,
            ARRAY(CAST(ROUND(PERCENTILE(dns, 0.5)) AS INT), COUNT(dns)) AS dnsBucketMidCount,
            COUNT(dns) AS dnsBucketCount,
            AVG(dns) AS dnsAvg,
            SUM(LN(GREATEST(dns, 0.000001))) AS dnsSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS dns

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE dnsBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(tcpBucket, tcpBucketMidCount)))) AS tcpHistogram,
        SUM(tcpAvg * tcpBucketCount) / SUM(tcpBucketCount) AS tcpAvg,
        SUM(tcpSumLn) AS tcpSumLn,
        SUM(tcpBucketCount) AS tcpBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            tcpBucket,
            ARRAY(CAST(ROUND(PERCENTILE(tcp, 0.5)) AS INT), COUNT(tcp)) AS tcpBucketMidCount,
            COUNT(tcp) AS tcpBucketCount,
            AVG(tcp) AS tcpAvg,
            SUM(LN(GREATEST(tcp, 0.000001))) AS tcpSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS tcp

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE tcpBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(tlsBucket, tlsBucketMidCount)))) AS tlsHistogram,
        SUM(tlsAvg * tlsBucketCount) / SUM(tlsBucketCount) AS tlsAvg,
        SUM(tlsSumLn) AS tlsSumLn,
        SUM(tlsBucketCount) AS tlsBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            tlsBucket,
            ARRAY(CAST(ROUND(PERCENTILE(tls, 0.5)) AS INT), COUNT(tls)) AS tlsBucketMidCount,
            COUNT(tls) AS tlsBucketCount,
            AVG(tls) AS tlsAvg,
            SUM(LN(GREATEST(tls, 0.000001))) AS tlsSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS tls

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE tlsBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(ttfbBucket, ttfbBucketMidCount)))) AS ttfbHistogram,
        SUM(ttfbAvg * ttfbBucketCount) / SUM(ttfbBucketCount) AS ttfbAvg,
        SUM(ttfbSumLn) AS ttfbSumLn,
        SUM(ttfbBucketCount) AS ttfbBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            ttfbBucket,
            ARRAY(CAST(ROUND(PERCENTILE(ttfb, 0.5)) AS INT), COUNT(ttfb)) AS ttfbBucketMidCount,
            COUNT(ttfb) AS ttfbBucketCount,
            AVG(ttfb) AS ttfbAvg,
            SUM(LN(GREATEST(ttfb, 0.000001))) AS ttfbSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS ttfb

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE ttfbBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(fcpBucket, fcpBucketMidCount)))) AS fcpHistogram,
        SUM(fcpAvg * fcpBucketCount) / SUM(fcpBucketCount) AS fcpAvg,
        SUM(fcpSumLn) AS fcpSumLn,
        SUM(fcpBucketCount) AS fcpBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            fcpBucket,
            ARRAY(CAST(ROUND(PERCENTILE(fcp, 0.5)) AS INT), COUNT(fcp)) AS fcpBucketMidCount,
            COUNT(fcp) AS fcpBucketCount,
            AVG(fcp) AS fcpAvg,
            SUM(LN(GREATEST(fcp, 0.000001))) AS fcpSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS fcp

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE fcpBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(lcpBucket, lcpBucketMidCount)))) AS lcpHistogram,
        SUM(lcpAvg * lcpBucketCount) / SUM(lcpBucketCount) AS lcpAvg,
        SUM(lcpSumLn) AS lcpSumLn,
        SUM(lcpBucketCount) AS lcpBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            lcpBucket,
            ARRAY(CAST(ROUND(PERCENTILE(lcp, 0.5)) AS INT), COUNT(lcp)) AS lcpBucketMidCount,
            COUNT(lcp) AS lcpBucketCount,
            AVG(lcp) AS lcpAvg,
            SUM(LN(GREATEST(lcp, 0.000001))) AS lcpSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS lcp

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE lcpBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(rttBucket, rttBucketMidCount)))) AS rttHistogram,
        SUM(rttAvg * rttBucketCount) / SUM(rttBucketCount) AS rttAvg,
        SUM(rttSumLn) AS rttSumLn,
        SUM(rttBucketCount) AS rttBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            rttBucket,
            ARRAY(CAST(ROUND(PERCENTILE(rtt, 0.5)) AS INT), COUNT(rtt)) AS rttBucketMidCount,
            COUNT(rtt) AS rttBucketCount,
            AVG(rtt) AS rttAvg,
            SUM(LN(GREATEST(rtt, 0.000001))) AS rttSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS rtt

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE rttBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(rageClicksBucket, rageClicksBucketMidCount)))) AS rageClicksHistogram,
        SUM(rageClicksAvg * rageClicksBucketCount) / SUM(rageClicksBucketCount) AS rageClicksAvg,
        SUM(rageClicksSumLn) AS rageClicksSumLn,
        SUM(rageClicksBucketCount) AS rageClicksBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            rageClicksBucket,
            ARRAY(CAST(ROUND(PERCENTILE(rageClicks, 0.5)) AS INT), COUNT(rageClicks)) AS rageClicksBucketMidCount,
            COUNT(rageClicks) AS rageClicksBucketCount,
            AVG(rageClicks) AS rageClicksAvg,
            SUM(LN(GREATEST(rageClicks, 0.000001))) AS rageClicksSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
                CASE
                    WHEN (rageClicks IS NULL OR rageClicks < 0) THEN NULL
                    WHEN rageClicks = 0 THEN 0
                    WHEN rageClicks <= 100 THEN rageClicks
                    WHEN rageClicks <= 600 THEN FLOOR((rageClicks - 100) / 10) + 101
                    ELSE 151
                END AS rageClicksBucket,
                CASE
                    WHEN (rageClicks IS NULL OR rageClicks < 0) THEN NULL
                    WHEN rageClicks > 600 THEN 600
                    ELSE rageClicks
                END AS rageClicks

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE rageClicksBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(clsBucket, clsBucketMidCount)))) AS clsHistogram,
        SUM(clsAvg * clsBucketCount) / SUM(clsBucketCount) AS clsAvg,
        SUM(clsSumLn) AS clsSumLn,
        SUM(clsBucketCount) AS clsBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            clsBucket,
            ARRAY(CAST(ROUND(PERCENTILE(cls, 0.5)) AS INT), COUNT(cls)) AS clsBucketMidCount,
            COUNT(cls) AS clsBucketCount,
            AVG(cls) AS clsAvg,
            SUM(LN(GREATEST(cls, 0.000001))) AS clsSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS cls

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE clsBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(fidBucket, fidBucketMidCount)))) AS fidHistogram,
        SUM(fidAvg * fidBucketCount) / SUM(fidBucketCount) AS fidAvg,
        SUM(fidSumLn) AS fidSumLn,
        SUM(fidBucketCount) AS fidBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            fidBucket,
            ARRAY(CAST(ROUND(PERCENTILE(fid, 0.5)) AS INT), COUNT(fid)) AS fidBucketMidCount,
            COUNT(fid) AS fidBucketCount,
            AVG(fid) AS fidAvg,
            SUM(LN(GREATEST(fid, 0.000001))) AS fidSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS fid

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE fidBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(tbtBucket, tbtBucketMidCount)))) AS tbtHistogram,
        SUM(tbtAvg * tbtBucketCount) / SUM(tbtBucketCount) AS tbtAvg,
        SUM(tbtSumLn) AS tbtSumLn,
        SUM(tbtBucketCount) AS tbtBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            tbtBucket,
            ARRAY(CAST(ROUND(PERCENTILE(tbt, 0.5)) AS INT), COUNT(tbt)) AS tbtBucketMidCount,
            COUNT(tbt) AS tbtBucketCount,
            AVG(tbt) AS tbtAvg,
            SUM(LN(GREATEST(tbt, 0.000001))) AS tbtSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS tbt

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE tbtBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(ttiBucket, ttiBucketMidCount)))) AS ttiHistogram,
        SUM(ttiAvg * ttiBucketCount) / SUM(ttiBucketCount) AS ttiAvg,
        SUM(ttiSumLn) AS ttiSumLn,
        SUM(ttiBucketCount) AS ttiBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            ttiBucket,
            ARRAY(CAST(ROUND(PERCENTILE(tti, 0.5)) AS INT), COUNT(tti)) AS ttiBucketMidCount,
            COUNT(tti) AS ttiBucketCount,
            AVG(tti) AS ttiAvg,
            SUM(LN(GREATEST(tti, 0.000001))) AS ttiSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
                END AS tti

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE ttiBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(redirectBucket, redirectBucketMidCount)))) AS redirectHistogram,
        SUM(redirectAvg * redirectBucketCount) / SUM(redirectBucketCount) AS redirectAvg,
        SUM(redirectSumLn) AS redirectSumLn,
        SUM(redirectBucketCount) AS redirectBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            redirectBucket,
            ARRAY(CAST(ROUND(PERCENTILE(redirect, 0.5)) AS INT), COUNT(redirect)) AS redirectBucketMidCount,
            COUNT(redirect) AS redirectBucketCount,
            AVG(redirect) AS redirectAvg,
            SUM(LN(GREATEST(redirect, 0.000001))) AS redirectSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
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
            -- Sample from the raw table
            --
            FROM (
                SELECT *
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE redirectBucket IS NOT NULL
        GROUP BY
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
LEFT JOIN
(
    SELECT
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
        TO_JSON(MAP_FROM_ENTRIES(COLLECT_LIST(STRUCT(inpBucket, inpBucketMidCount)))) AS inpHistogram,
        SUM(inpAvg * inpBucketCount) / SUM(inpBucketCount) AS inpAvg,
        SUM(inpSumLn) AS inpSumLn,
        SUM(inpBucketCount) AS inpBucketCount
    FROM (
        SELECT
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
            COUNT(*) AS beacons,
            inpBucket,
            ARRAY(CAST(ROUND(PERCENTILE(inp, 0.5)) AS INT), COUNT(inp)) AS inpBucketMidCount,
            COUNT(inp) AS inpBucketCount,
            AVG(inp) AS inpAvg,
            SUM(LN(GREATEST(inp, 0.000001))) AS inpSumLn
        FROM 
        (
            SELECT
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
                            THEN LEFT(operatingSystemVersion, INSTR(operatingSystemVersion, '.') - 1)
                        ELSE operatingSystemVersion
                    END
                    , '') AS osVersion,
                REPLACE(COALESCE(beaconTypeName, ''), '_', ' ') AS beaconType,
                COALESCE(countryCode, '') AS country,
                COALESCE(visibilityStateName, '') AS visibilityState,
                REPLACE(COALESCE(navigationTypeName, ''), '_', ' ') AS navigationType,
                COALESCE(httpProtocolName, '') AS protocol,
                COALESCE(ipVersionName, '') AS ipVersion,
                COALESCE(landingPageName, '') AS landingPage,

                --
                -- Timers
                --
                CASE
                    WHEN (inpFromParams IS NULL OR inpFromParams < 0) THEN NULL
                    WHEN inpFromParams = 0 THEN 0
                    WHEN inpFromParams <= 1000 THEN FLOOR(inpFromParams / 10) + 1
                    WHEN inpFromParams <= 6000 THEN FLOOR((inpFromParams - 1000) / 100) + 101
                    ELSE 151
                END AS inpBucket,
                CASE
                    WHEN (inpFromParams IS NULL OR inpFromParams < 0) THEN NULL
                    WHEN inpFromParams > 6000 THEN 6000
                    ELSE CAST(inpFromParams AS INT)
                END AS inp

            --
            -- Sample from the raw table
            --
            FROM (
                SELECT *,
                    GET_JSON_OBJECT(additionalfieldsjson, "$.params['et.inp.inc']") AS inpFromParams
                FROM rum_prd_beacon_fact_dswb_0
                WHERE TIME_BUCKET_DAY = UNIX_MILLIS(TO_TIMESTAMP('{{DATE}} 00:00:00.00 -0000'))
                    AND beaconTypeName IN ('page view', 'spa_hard', 'spa', 'bfcache')
                    AND pageLoadTime IS NOT NULL
                    AND pageLoadTime > 0
                    AND appId = {{APP_ID}}
                    AND akamaiBmTypeName NOT IN (
                        'Unknown Bot', 'Customer-Categorized Bot', 'Bot', 'Synthetic Monitoring',
                        'Akamai Known Synthetic Monitoring', 'Akamai Known Bot'
                    )
            ) TABLESAMPLE ({{BEACON_PCT}} percent)
        )
        WHERE inpBucket IS NOT NULL
        GROUP BY
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
            inpBucket
        )
    GROUP BY
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
    ) inp
USING (
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
WHERE plt.beacons >= {{MIN_BEACON_COUNT}}
