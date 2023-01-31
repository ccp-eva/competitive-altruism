---
title: "Chimpanzees engage in competitive altruism in a triadic Ultimatum Game"
subtitle: "Model summaries"
author: "Luke Maurits <<luke_maurits@eva.mpg.de>>"
date: "2023-01-31"
output:
  pdf_document:
    number_sections: TRUE
urlcolor: blue
---



# Pre-registered models of total proportional offer

## M1: Proportional total offer, dyadic vs triadic



### Posterior predictive distribution for total proportional offers in 8th session


|        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-------|--------------:|-------------:|-------------:|
|Dyadic  |           0.38|          0.02|          0.88|
|Triadic |           0.34|          0.03|          0.80|

### Posterior predictive distribution for difference in total proportional offers in 8th session


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|          -0.04|         -0.65|          0.58|

## M2: Proportional total offer, consecutive vs simultaneous


### Posterior predictive distribution for total proportional offers in 8th triadic session


|             | Posterior mean| 95% HPD lower| 95% HPD upper|
|:------------|--------------:|-------------:|-------------:|
|Simultaneous |           0.30|          0.01|          0.81|
|Consecutive  |           0.34|          0.01|          0.86|

Posterior probability that mean consecutive offer is higher than mean simulteanous offer:


```
## [1] 0.829
```

Posterior predictive distribution for difference in offer between conditions:

| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.04|         -0.62|          0.68|
\newpage

# Models of tendency for final offfers to exceed initial offers within sessions



### Marginalised over session probabilities of increasing within a session


|        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-------|--------------:|-------------:|-------------:|
|Dyadic  |           0.36|          0.21|          0.52|
|Triadic |           0.60|          0.39|          0.79|

### Per-session probabilities

#### Dyadic


| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.32|          0.17|          0.50|
|       2|           0.33|          0.18|          0.49|
|       3|           0.33|          0.19|          0.48|
|       4|           0.33|          0.21|          0.47|
|       5|           0.34|          0.22|          0.46|
|       6|           0.34|          0.23|          0.46|
|       7|           0.35|          0.24|          0.47|
|       8|           0.35|          0.24|          0.47|
|       9|           0.36|          0.25|          0.48|
|      10|           0.36|          0.25|          0.49|
|      11|           0.37|          0.25|          0.50|
|      12|           0.37|          0.25|          0.51|
|      13|           0.38|          0.24|          0.53|
|      14|           0.39|          0.23|          0.55|
|      15|           0.39|          0.22|          0.57|
|      16|           0.40|          0.21|          0.59|
#### Triadic

| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.51|          0.30|          0.71|
|       2|           0.52|          0.33|          0.71|
|       3|           0.53|          0.35|          0.71|
|       4|           0.54|          0.38|          0.71|
|       5|           0.56|          0.40|          0.71|
|       6|           0.57|          0.41|          0.72|
|       7|           0.58|          0.43|          0.73|
|       8|           0.60|          0.44|          0.74|
|       9|           0.61|          0.46|          0.75|
|      10|           0.62|          0.46|          0.76|
|      11|           0.63|          0.47|          0.78|
|      12|           0.64|          0.48|          0.79|
|      13|           0.65|          0.48|          0.81|
|      14|           0.66|          0.48|          0.82|
|      15|           0.67|          0.47|          0.84|
|      16|           0.68|          0.47|          0.86|

#### Per session contrast in probabilities (triadic - dyadic)


| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.18|         -0.09|          0.45|
|       2|           0.19|         -0.06|          0.44|
|       3|           0.20|         -0.03|          0.43|
|       4|           0.21|         -0.01|          0.42|
|       5|           0.22|          0.01|          0.41|
|       6|           0.23|          0.03|          0.41|
|       7|           0.23|          0.05|          0.42|
|       8|           0.24|          0.06|          0.42|
|       9|           0.25|          0.06|          0.43|
|      10|           0.26|          0.06|          0.44|
|      11|           0.26|          0.06|          0.46|
|      12|           0.27|          0.06|          0.47|
|      13|           0.27|          0.04|          0.49|
|      14|           0.28|          0.03|          0.50|
|      15|           0.28|          0.02|          0.52|
|      16|           0.29|          0.00|          0.54|

# Models of tendency to increase offers from trial to trial

## Relative to self



### Marginalised over sessions


|                        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-----------------------|--------------:|-------------:|-------------:|
|Previous offer accepted |           0.28|          0.19|          0.39|
|Previous offer rejected |           0.52|          0.39|          0.64|

### Accepted vs rejected contrast


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.23|          0.12|          0.34|

## Relative to previous trial winner



### Marginalised over sessions


|                        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-----------------------|--------------:|-------------:|-------------:|
|Previous offer accepted |           0.45|          0.29|          0.60|
|Previous offer rejected |           0.35|          0.22|          0.49|

\newpage

### Accepted vs rejected contrast


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           -0.1|         -0.21|          0.01|

# Models of tendency of second proposers to outbid first proposers

## Without accounting for value of first offer



### Posterior probability that second proposer becomes more likely to outbid first proposer as sessions increase


```
## [1] 0.88525
```

### Probability that second proposer offers more than first proposer in consecutive trials, marginalising over sessions


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.45|          0.26|          0.66|

### Per session probabilities that second proposer offers more than first proposer in consecutive trials


| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.39|          0.21|          0.60|
|       2|           0.40|          0.22|          0.60|
|       3|           0.40|          0.23|          0.60|
|       4|           0.41|          0.24|          0.61|
|       5|           0.42|          0.25|          0.61|
|       6|           0.43|          0.26|          0.62|
|       7|           0.44|          0.27|          0.63|
|       8|           0.45|          0.28|          0.63|
|       9|           0.46|          0.29|          0.65|
|      10|           0.47|          0.29|          0.65|
|      11|           0.48|          0.30|          0.66|
|      12|           0.49|          0.31|          0.67|
|      13|           0.50|          0.32|          0.68|
|      14|           0.51|          0.32|          0.69|
|      15|           0.51|          0.32|          0.71|
|      16|           0.52|          0.32|          0.72|

\newpage

## Stratifying by first offer



### Outbidding probabilities in first session, stratified by first offer

| First Offer| Baseline outbidding rate| Posterior mean| 95% HPD lower| 95% HPD upper| PP rate above chance| PP rate above basline|
|-----------:|------------------------:|--------------:|-------------:|-------------:|--------------------:|---------------------:|
|           0|                     0.80|           0.70|          0.48|          0.87|                 0.97|                  0.15|
|           1|                     0.65|           0.55|          0.32|          0.75|                 0.67|                  0.18|
|           2|                     0.54|           0.40|          0.21|          0.62|                 0.17|                  0.09|
|           3|                     0.38|           0.35|          0.17|          0.55|                 0.07|                  0.39|
|           4|                     0.24|           0.28|          0.12|          0.48|                 0.02|                  0.63|
|           5|                     0.13|           0.08|          0.01|          0.21|                 0.00|                  0.13|
|           6|                     0.08|           0.04|          0.00|          0.11|                 0.00|                  0.09|
|           7|                     0.02|           0.02|          0.00|          0.08|                 0.00|                  0.43|
|           8|                     0.00|           0.01|          0.00|          0.05|                 0.00|                  1.00|

### Outbidding probabilities in final session, stratified by first offer


| First Offer| Baseline outbidding rate| Posterior mean| 95% HPD lower| 95% HPD upper| PP rate above chance| PP rate above basline|
|-----------:|------------------------:|--------------:|-------------:|-------------:|--------------------:|---------------------:|
|           0|                     0.80|           0.84|          0.68|          0.95|                 1.00|                  0.76|
|           1|                     0.65|           0.74|          0.53|          0.89|                 0.98|                  0.84|
|           2|                     0.54|           0.61|          0.39|          0.79|                 0.87|                  0.77|
|           3|                     0.38|           0.56|          0.35|          0.75|                 0.74|                  0.96|
|           4|                     0.24|           0.48|          0.26|          0.69|                 0.44|                  0.98|
|           5|                     0.13|           0.16|          0.03|          0.39|                 0.00|                  0.54|
|           6|                     0.08|           0.08|          0.01|          0.24|                 0.00|                  0.43|
|           7|                     0.02|           0.05|          0.00|          0.18|                 0.00|                  0.76|
|           8|                     0.00|           0.03|          0.00|          0.12|                 0.00|                  1.00|

### Difference in outbidding probability between initial offers of 4 and 5


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.32|          0.09|          0.53|
