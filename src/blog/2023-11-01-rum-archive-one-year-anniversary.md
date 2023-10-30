---
title: RUM Archive One Year Anniversary
date: 2023-11-01 00:00:00
description: The RUM Archive was announced one year ago!  We're announcing a new feature called RUM Insights, as well as a preview of a Third-Party Resource dataset.
layout: layouts/blog.njk
tags: blog
author: Nic Jansma
toc: true
thumbnail: /blog/2023-11-01-rum-archive-one-year-anniversary.svg
---

The RUM Archive was released a year ago during the [performance.now() 2022](https://perfnow.nl/) conference in Amsterdam!  Let's review what's happened with the project over the last year, and then we can share some exciting new features we're adding.

First, a few notes on our October data release.

## Latest mPulse RUM Data Loaded

We've completed an export of mPulse daily RUM data into the BigQuery [`akamai-mpulse-rumarchive`](/datasets/#akamai-mpulse-rum) project up through 2023-10-31.

This brings the RUM Archive's [mPulse dataset](/datasets/#akamai-mpulse-rum) to a running total of 425 straight days of data available since 2022-09-01.  (There is also first-of-month data going back to 2021-10-01).

We plan to continue this daily export of the mPulse RUM data for the forseeable future.  Right now, we're updating the BigQuery tables approximately on a monthly cadence, where we release the previous month's data by the first few days of the next month.  We plan on automating this process further so that daily data can be uploaded on a daily cadence.

## RUM Archive Data In the Wild

One of our stated goals of the project is to make RUM data freely available so web performance nerds can use it for their own research.

We've received a lot of support for the project since its release, and look forward to making it better based on the community's feedback.

We know of a few places where RUM Archive data has been used, let's take a look!

[Annie Sullivan](https://twitter.com/anniesullie) was able to query the RUM Archive's data on Rage Clicks as part of research the Chrome Speed Metrics team was doing on whether to standardize the definition of a "rage click":

https://twitter.com/anniesullie/status/1621521096788049922

Our very own [Tim Vereecke](https://twitter.com/TimVereecke) has used the RUM Archive data in his presentation titled _Noise Cancelling RUM_ that's given at [P99](https://www.p99conf.io/agenda/), [We Love Speed](https://www.welovespeed.com/en/2023/speakers/#tim_vereecke) and [perf.now()](https://perfnow.nl/speakers):

https://twitter.com/TimVereecke/status/1598261516897202176

[Henri Helvetica](https://twitter.com/HenriHelvetica) also interviewed [Nic Jansma](https://twitter.com/nicj) for an introduction to using the RUM Archive:

https://www.youtube.com/watch?v=zH7XmsWmRCo

Are **you** using the RUM Archive data in an interesting way?  [Let us know](https://twitter.com/RUMArchive)!

## RUM Insights

Until now, the [rumarchive.com](https://rumarchive.com) domain has been mostly a documentation website, with instructions on how you can query the BigQuery RUM data and a few example SQL queries.

We're now announcing a section for the site called [_RUM Insights_](/insights)!

<img src="/blog/2023-11-01-rum-archive-one-year-anniversary-insights.png" style="width: 50%; height: auto"/>

[RUM Insights](/insights) captures a collection of basic visualizations for the data contained in the RUM Archive. It's goal is to allow users to get a feel for the most important insights that can be gained from the data, without having to execute SQL queries themselves.

For more details, check out our [blog post](/blog/2023-11-01-rum-archive-insights) on the topic!

## Third-Party Resource Dataset Preview

We've been working on new dataset to complement the mPulse Page Load dataset: [Third-Party Resources](/docs/tables/#third-party-resources).

mPulse and boomerang.js capture [ResourceTiming](https://www.w3.org/TR/resource-timing/) data for all of the sub-resources (such as JavaScript, CSS, images, etc) on the page, on every mPulse Page Load beacon.

With this data, in aggregate, we can easily spot third-party components (those loaded by multiple domains) such as libraries, analytics scripts, widgets, fonts, etc.

We're going to start exporting the Top &gt;500 third-party resources we see each day, similar to how we share Page Load data.  Each third-party resource URL will have information on its popularity, performance and size.  These URL trends should be trackable over time as well.

For more details, check out our [blog post](/blog/2023-11-01-rum-archive-third-party-resource-dataset) on the topic!

That's all for this month, thanks for checking us out!
