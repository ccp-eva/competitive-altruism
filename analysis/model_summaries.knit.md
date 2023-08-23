---
title: "Chimpanzees engage in competitive altruism in a triadic Ultimatum Game"
subtitle: "Model summaries"
author: "Luke Maurits <<luke_maurits@eva.mpg.de>>"
date: "2023-08-23"
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
|Dyadic  |           0.38|          0.01|          0.89|
|Triadic |           0.35|          0.03|          0.81|

### Posterior predictive distribution for difference in total proportional offers in 8th session


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|          -0.03|         -0.64|          0.58|

## M2: Proportional total offer, consecutive vs simultaneous


### Posterior predictive distribution for total proportional offers in 8th triadic session


|             | Posterior mean| 95% HPD lower| 95% HPD upper|
|:------------|--------------:|-------------:|-------------:|
|Simultaneous |           0.30|          0.01|          0.81|
|Consecutive  |           0.33|          0.01|          0.84|

Posterior probability that mean consecutive offer is higher than mean simulteanous offer:


```
## [1] 0.82375
```

Posterior predictive distribution for difference in offer between conditions:

| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.04|          -0.6|          0.67|
\newpage

# Models of tendency for final offfers to exceed initial offers within sessions



### Marginalised over session probabilities of increasing within a session


|        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-------|--------------:|-------------:|-------------:|
|Dyadic  |           0.35|          0.20|          0.52|
|Triadic |           0.59|          0.37|          0.79|

### Per-session probabilities

#### Dyadic


| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.31|          0.15|          0.49|
|       2|           0.31|          0.17|          0.48|
|       3|           0.32|          0.18|          0.47|
|       4|           0.32|          0.19|          0.47|
|       5|           0.33|          0.20|          0.46|
|       6|           0.33|          0.22|          0.46|
|       7|           0.34|          0.23|          0.46|
|       8|           0.35|          0.23|          0.46|
|       9|           0.35|          0.24|          0.47|
|      10|           0.36|          0.24|          0.48|
|      11|           0.37|          0.24|          0.50|
|      12|           0.37|          0.24|          0.51|
|      13|           0.38|          0.24|          0.53|
|      14|           0.39|          0.23|          0.55|
|      15|           0.40|          0.23|          0.58|
|      16|           0.40|          0.22|          0.60|
#### Triadic

| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.48|          0.28|          0.68|
|       2|           0.50|          0.31|          0.68|
|       3|           0.51|          0.33|          0.68|
|       4|           0.53|          0.36|          0.69|
|       5|           0.54|          0.38|          0.70|
|       6|           0.56|          0.40|          0.71|
|       7|           0.57|          0.42|          0.72|
|       8|           0.58|          0.43|          0.73|
|       9|           0.60|          0.44|          0.74|
|      10|           0.61|          0.45|          0.76|
|      11|           0.62|          0.46|          0.77|
|      12|           0.64|          0.47|          0.79|
|      13|           0.65|          0.47|          0.81|
|      14|           0.66|          0.47|          0.82|
|      15|           0.67|          0.47|          0.84|
|      16|           0.68|          0.47|          0.86|

#### Per session contrast in probabilities (triadic - dyadic)


| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.18|         -0.09|          0.43|
|       2|           0.19|         -0.06|          0.42|
|       3|           0.20|         -0.03|          0.42|
|       4|           0.20|         -0.01|          0.41|
|       5|           0.21|          0.01|          0.41|
|       6|           0.22|          0.03|          0.41|
|       7|           0.23|          0.04|          0.41|
|       8|           0.24|          0.05|          0.41|
|       9|           0.24|          0.06|          0.42|
|      10|           0.25|          0.05|          0.43|
|      11|           0.26|          0.05|          0.45|
|      12|           0.26|          0.04|          0.46|
|      13|           0.27|          0.04|          0.48|
|      14|           0.27|          0.03|          0.50|
|      15|           0.28|          0.01|          0.52|
|      16|           0.28|         -0.01|          0.53|

# Models of tendency to increase offers from trial to trial

## Relative to self



### Marginalised over sessions


|                        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-----------------------|--------------:|-------------:|-------------:|
|Previous offer accepted |           0.28|          0.19|          0.38|
|Previous offer rejected |           0.53|          0.40|          0.66|

### Accepted vs rejected contrast


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.24|          0.14|          0.35|

## Relative to previous trial winner



### Marginalised over sessions


|                        | Posterior mean| 95% HPD lower| 95% HPD upper|
|:-----------------------|--------------:|-------------:|-------------:|
|Previous offer accepted |           0.45|          0.30|          0.61|
|Previous offer rejected |           0.35|          0.22|          0.51|

\newpage

### Accepted vs rejected contrast


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           -0.1|         -0.21|          0.01|

# Models of tendency of second proposers to outbid first proposers

## Without accounting for value of first offer



### Posterior probability that second proposer becomes more likely to outbid first proposer as sessions increase


```
## [1] 0.8835
```

### Probability that second proposer offers more than first proposer in consecutive trials, marginalising over sessions


| Posterior mean| 95% HPD lower| 95% HPD upper|
|--------------:|-------------:|-------------:|
|           0.46|          0.27|          0.66|

### Per session probabilities that second proposer offers more than first proposer in consecutive trials


| Session| Posterior mean| 95% HPD lower| 95% HPD upper|
|-------:|--------------:|-------------:|-------------:|
|       1|           0.39|          0.22|          0.60|
|       2|           0.40|          0.23|          0.60|
|       3|           0.41|          0.24|          0.60|
|       4|           0.42|          0.25|          0.61|
|       5|           0.43|          0.26|          0.61|
|       6|           0.44|          0.27|          0.62|
|       7|           0.44|          0.28|          0.63|
|       8|           0.45|          0.29|          0.63|
|       9|           0.46|          0.30|          0.64|
|      10|           0.47|          0.30|          0.65|
|      11|           0.48|          0.31|          0.66|
|      12|           0.49|          0.31|          0.67|
|      13|           0.50|          0.32|          0.68|
|      14|           0.51|          0.33|          0.69|
|      15|           0.52|          0.33|          0.71|
|      16|           0.53|          0.33|          0.72|

\newpage

## Stratifying by first offer



### Estimated offering preferences

A probability distribution reflecting our estimate of proposer's preferred
offers in the absence of competition was calculated on the basis of first offers
in consecutive trials.  A distribution was calculated separately for sessions
1 through 16 as follows.  In each session and for each possible offer, the
proportion of observed offers in the 1st, 2nd, 3rd,..., 8th trial equal to that
possible offer was computed.  The session probability for that offer was set
to the weighted mean of these per-trial probabilities, with each trial receiving
half the weight of the previous trial, i.e. 2nd trial data has half the weight
of 1st trial data, 3rd trial data has half the weight of 2nd trial data, and so
on.  Under this scheme, approximately 95% of the contribution to the estimate
comes from the first half of session.  The 16 session distributions are then
combined into a weighted mean where each session receives 3/4 the weight of
the previous session, i.e. influence decays across sessions less steeply than
across trials, since sessions are separated by a much longer time.  The table
below shows both the final offering probabilities and the baseline outbidding
probabilities estimated on the basis of 10,000 simulated trials of comparing
"first" and "second" offers drawn from the preferred offer distribution.


| Offer| Preference probability| Baseline outbiding probability|
|-----:|----------------------:|------------------------------:|
|     0|                   0.23|                           0.77|
|     1|                   0.15|                           0.62|
|     2|                   0.17|                           0.45|
|     3|                   0.19|                           0.27|
|     4|                   0.10|                           0.16|
|     5|                   0.08|                           0.10|
|     6|                   0.03|                           0.06|
|     7|                   0.04|                           0.01|
|     8|                   0.02|                           0.00|

### Posterior probability that second proposer becomes more likely to outbid first proposer as sessions increase

#### With previous offer rejected:


```
## [1] 0.95325
```

#### With previous offer accepted:


```
## [1] 0.48225
```

### Outbidding probabilities in first session, stratified by first offer


| First Offer|Previously accepted | Baseline| Posterior mean| 95% HPD lower| 95% HPD upper| PP rate above chance| PP rate above basline|
|-----------:|:-------------------|--------:|--------------:|-------------:|-------------:|--------------------:|---------------------:|
|           0|FALSE               |     0.77|           0.75|          0.42|          0.93|                 0.95|                  0.50|
|           1|FALSE               |     0.62|           0.62|          0.27|          0.87|                 0.77|                  0.52|
|           2|FALSE               |     0.45|           0.38|          0.11|          0.69|                 0.22|                  0.32|
|           3|FALSE               |     0.27|           0.33|          0.09|          0.63|                 0.12|                  0.64|
|           4|FALSE               |     0.16|           0.23|          0.05|          0.52|                 0.03|                  0.69|
|           5|FALSE               |     0.10|           0.07|          0.01|          0.23|                 0.00|                  0.23|
|           6|FALSE               |     0.06|           0.04|          0.00|          0.14|                 0.00|                  0.17|
|           7|FALSE               |     0.01|           0.02|          0.00|          0.10|                 0.00|                  0.72|
|           8|FALSE               |     0.00|           0.01|          0.00|          0.06|                 0.00|                  1.00|
|           0|TRUE                |     0.77|           0.81|          0.51|          0.96|                 0.98|                  0.69|
|           1|TRUE                |     0.62|           0.69|          0.33|          0.92|                 0.88|                  0.72|
|           2|TRUE                |     0.45|           0.47|          0.14|          0.78|                 0.44|                  0.54|
|           3|TRUE                |     0.27|           0.41|          0.11|          0.73|                 0.30|                  0.80|
|           4|TRUE                |     0.16|           0.30|          0.06|          0.62|                 0.10|                  0.83|
|           5|TRUE                |     0.10|           0.10|          0.01|          0.31|                 0.00|                  0.38|
|           6|TRUE                |     0.06|           0.05|          0.00|          0.18|                 0.00|                  0.30|
|           7|TRUE                |     0.01|           0.03|          0.00|          0.12|                 0.00|                  0.81|
|           8|TRUE                |     0.00|           0.02|          0.00|          0.08|                 0.00|                  1.00|

### Outbidding probabilities in final session, stratified by first offer


| First Offer|Previously accepted | Baseline| Posterior mean| 95% HPD lower| 95% HPD upper| PP rate above chance| PP rate above basline|
|-----------:|:-------------------|--------:|--------------:|-------------:|-------------:|--------------------:|---------------------:|
|           0|FALSE               |     0.77|           0.92|          0.71|          0.99|                 1.00|                  0.95|
|           1|FALSE               |     0.62|           0.86|          0.56|          0.98|                 0.99|                  0.95|
|           2|FALSE               |     0.45|           0.71|          0.35|          0.92|                 0.91|                  0.94|
|           3|FALSE               |     0.27|           0.66|          0.29|          0.90|                 0.85|                  0.98|
|           4|FALSE               |     0.16|           0.54|          0.18|          0.85|                 0.60|                  0.98|
|           5|FALSE               |     0.10|           0.23|          0.03|          0.59|                 0.06|                  0.80|
|           6|FALSE               |     0.06|           0.13|          0.01|          0.42|                 0.01|                  0.71|
|           7|FALSE               |     0.01|           0.09|          0.00|          0.32|                 0.00|                  0.95|
|           8|FALSE               |     0.00|           0.05|          0.00|          0.21|                 0.00|                  1.00|
|           0|TRUE                |     0.77|           0.80|          0.50|          0.95|                 0.98|                  0.69|
|           1|TRUE                |     0.62|           0.69|          0.33|          0.91|                 0.89|                  0.71|
|           2|TRUE                |     0.45|           0.46|          0.15|          0.77|                 0.42|                  0.53|
|           3|TRUE                |     0.27|           0.41|          0.12|          0.71|                 0.27|                  0.81|
|           4|TRUE                |     0.16|           0.29|          0.07|          0.60|                 0.08|                  0.83|
|           5|TRUE                |     0.10|           0.10|          0.01|          0.31|                 0.00|                  0.38|
|           6|TRUE                |     0.06|           0.05|          0.00|          0.19|                 0.00|                  0.29|
|           7|TRUE                |     0.01|           0.03|          0.00|          0.13|                 0.00|                  0.80|
|           8|TRUE                |     0.00|           0.02|          0.00|          0.08|                 0.00|                  1.00|
