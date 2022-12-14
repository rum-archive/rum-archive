CREATE TABLE `%PROJECT%.%DATASET%.%PREFIX%-resources`
(
    DATE DATE,
    URL STRING,
    DEVICETYPE STRING,
    USERAGENTFAMILY STRING,
    USERAGENTVERSION STRING,
    DEVICEMODEL STRING,
    OS STRING,
    OSVERSION STRING,
    COUNTRY STRING,
    PROTOCOL STRING,
    INITIATORTYPE STRING,
    ASSETTYPE STRING,
    TOTALHISTOGRAM STRING,
    TOTALAVG FLOAT64,
    TOTALSUMLN FLOAT64,
    TOTALCOUNT INTEGER,
    DNSHISTOGRAM STRING,
    DNSAVG FLOAT64,
    DNSSUMLN FLOAT64,
    DNSCOUNT INTEGER,
    TCPHISTOGRAM STRING,
    TCPAVG FLOAT64,
    TCPSUMLN FLOAT64,
    TCPCOUNT INTEGER,
    TLSHISTOGRAM STRING,
    TLSAVG FLOAT64,
    TLSSUMLN FLOAT64,
    TLSCOUNT INTEGER,
    TTFBHISTOGRAM STRING,
    TTFBAVG FLOAT64,
    TTFBSUMLN FLOAT64,
    TTFBCOUNT INTEGER,
    DOWNLOADHISTOGRAM STRING,
    DOWNLOADAVG FLOAT64,
    DOWNLOADSUMLN FLOAT64,
    DOWNLOADCOUNT INTEGER
) PARTITION BY DATE
;
