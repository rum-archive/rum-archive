---
title: Tables
description: Table structure
layout: layouts/page.njk
tags: docs
order: 2
---

## Page Loads

| Dimension        | Example Values                      |      Cardinality |
|:-----------------|:------------------------------------|-----------------:|
| Source           | `mpulse`                            |                1 |
| Site             | (NULL for mPulse)                   |                0 |
| Date             | 2022-01-01                          | (grows each day) |
| DeviceType       | `Mobile` `Desktop` `Tablet`         |                3 |
| UserAgentFamily  | `Chrome` `Mobile Safari`            |             ~100 |
| UserAgentVersion | `99` `12`                           |             ~350 |
| DeviceModel      | `Apple iPhone` `Samsung Android 11` |            ~2000 |
| OS               | `Android OS` `Windows` `iOS`        |              ~30 |
| OS Version       | `10` `15`                           |              ~75 |
| Beacon Type      | `page view` `spa_hard`              |                2 |
| COUNTRY          | `US` `GB` `GB`                      |             ~230 |
| VISIBILITYSTATE  | `visible` `hidden` `partial`        |                3 |
| NAVIGATIONTYPE   | `navigate` `back_forward` `reload`  |                3 |
| PROTOCOL         | `h2` `http/1.1` h3                  |              ~10 |
| IPVERSION        | `IPv4` `IPv6`                       |                3 |
| LANDINGPAGE      | `true` `false`                      |                3 |

## Resources

ResourceTiming
​
