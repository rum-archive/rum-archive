---
title: RUM Archive Insights with Baseline Support
date: 2024-05-14
description: Insights now has a section outlining how RUM data intersects with the Web Platform Baseline project.
layout: layouts/blog.njk
tags: blog
author: Robin Marx
toc: true
thumbnail: /assets/baseline-logo.png
---

The [Web Platform Baseline](https://web.dev/baseline) project aims to track when exactly Web features became available in all major browsers (Chrome, Edge, Firefox, Safari). This is important since not all browsers implement all features at the same time; using cutting edge feature X on browser A might mean you leave some of your users on browser B out in the cold (or having to implement a costly fallback).

However, you also don't want to only use features from Baseline 2017, "just to be safe", because that would mean missing out on many already widely available features. In practice, you want to utilize features that **almost all of your users** will benefit from.

To help you figure out which features those are and which Baseline year you should target, the [RUM Archive Insights](/insights/) has added a [Baseline section](/insights/#baseline) outlining how RUM data intersects with Baseline features.  Supported percentages are of observed **Desktop** and **Mobile** RUM Archive traffic **on the first Tuesday of April 2024** that had support for ALL the features in a particular Baseline year.

Additionally, we include a list of all features included in each Baseline year by clicking on that version, which can help you understand the trade-offs between desired browser features and the percentage of global traffic supporting those features and that Baseline year.

<a href="/insights/#baseline">
  <img src="screenshot.png" alt="RUM Insights Baseline" />
</a>

Please [check it out and give us feedback](/insights/#baseline)!  As the Baseline project evolves we hope to expand our insights as well.
