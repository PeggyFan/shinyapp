---
title       : Membership in Associations in 85 countries using the World Values Survey, 1981-2007
author      : Peggy Fan
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## The question

Civic participation is seen as a cornerstone of democracy in fields of political science, sociology, and education. One way to measure civic participation is looking at the degree to which an individual participates in organizations outside of family and work. Such organizations or associations are often the foundation to social capital and network. 

This app presents data from a question from the World Values Survey (one of the oldest cross-national social surveys in the world) that asks: Are you a member of the following association: sports, arts, labor, politics, environment, women's rights, human rights, charity, or other.

The analyses focus on the gender and education attainment of the __

---
## The data

The raw data from World Values Survey was cleaned and the variables of interest, gender and educational attainment, were extracted along with some country-level information. The data is further aggregated to the country level for this exercise. However, with a dataset like this:


```
  iso3  region participation country   male female lower.class
1  ALB region2        0.5263 Albania 0.5834 0.4703      0.4286
2  AND region1        0.6700 Andorra 0.7237 0.6160      0.4118
  working.class lower.middle.class upper.middle.class upper.class
1        0.4745             0.5997             0.6752      0.6429
2        0.6116             0.6509             0.7624      0.6667
  primary.education secondary.incomplete secondary.vocational
1            0.4565               0.4894               0.5608
2            0.5254               0.6136               0.6815
  secondary.preparatory tertiary.incomplete tertiary
1                0.5833              0.6957   0.7283
2                0.6319              0.7321   0.8326
```

It is difficult to observe the trends in terms of regions, gender, and education.

---
## The App

The app gives graphical and tabular representations of the data to faciliate data exploration.
It provides the descriptive analyses of associational membership on geagraphy, gender, and education attainment. 

The app gives regional averages by categories, such as this:

![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2.png) 

--- 
## The App (continued)
The app also gives country-specific data on gender and education attainment, such as:

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3.png) 

---

## Final words

This app gives a comprehenisve overview of the World Values Survey data and allows you to explore
with regional and country as units of analyses and making comparisons.

Check out the app at <https://peggyfan.shinyapps.io/shinyapps/>

