## Version 1.6 (2026-09)

* The [Cloudflare BEACON Dataset](/datasets#cloudflare-beacon-dataset) has been added
* The Page Loads table gained 3 new [dimensions](/docs/tables#dimensions) in the Cloudflare dataset:
  * `USERAGENTENGINE` and `USERAGENTENGINEVERSION`: the browser engine family and version
  * `INDUSTRY`: the industry category of the site
* The Page Loads table gained 8 new [timers and metrics](/docs/tables#timers-and-metrics) in the Cloudflare dataset:
  * `TRANSFERSIZE`: the transfer size (in bytes) of the HTML document
  * `INTERIMRESPONSE`: the time to the first interim (`1xx`) response, such as `103 Early Hints`
  * `LCPLOADDELAY`, `LCPLOADTIME` and `LCPRENDERDELAY`: the Largest Contentful Paint sub-parts
  * `INPINPUTDELAY`, `INPPROCESSINGDURATION` and `INPPRESENTATIONDELAY`: the Interaction to Next Paint sub-parts

## 2026-03-11

* The [Akamai mPulse Top 100](https://rumarchive.com/datasets/#akamai-mpulse-rum) and [Akamai Employee Individual Websites](/datasets#akamai-employee-individual-websites-datasets) Datasets had empty INP data from 2024-02-14 through 2026-03-09 due to a pipeline error.  This has been fixed in the 2026-03-10 data going forward.

## Version 1.5 (2025-09)

* [Akamai Employee Individual Websites Datasets](/datasets#akamai-employee-individual-websites-datasets) have been added

## Version 1.4 (2024-08)

* [Unattributed Navigation Overhead (UNO)](https://calendar.perfplanet.com/2024/uno/) has been added to the Page Loads table

## Version 1.3 (2024-04)

* Starting with `2024-04-01` onward, the mPulse Page Load and Third-Party Resource datasets now include minor version numbers for the following browsers:
  * `Safari`
  * `Mobile Safari`
  * `Mobile Safari UI/WKWebView`
* Starting with `2024-04-01` onward, the mPulse Page Load and Third-Party Resource datasets now include minor version numbers for the following operating systems:
  * `iOS`
  * `iPadOS`

## Version 1.2 (2023-11)

* Third-Party Resource data is now available, see the [blog post](/blog/2023-11-01-rum-archive-third-party-resource-data) for details.
* The mPulse Page Load dataset had incorrect `*AVG` column calculations.  Those columns have been `NULL`ed out for all data prior to 2023-11-01.

## Version 1.1 (2023-01)

* The RUM Archive's mPulse dataset has a breaking change in the `rageClicksHistogram` column (starting 2023-01-01), see the [blog post](/blog/2023-03-16-mpulse-january-data-rage-clicks-change) for details.

## Version 1.0 (2022-10)

* The RUM Archive is open for business!
