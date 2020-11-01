
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Positive Rate Proportion Dashboard <img src="./inst/data/Coronavirus.png" align="right" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of Positive Rate Proportion Dashboard is to estimate of the
distribution of COVID-19 test positivity rates in communities.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("alexanderjwhite/covid_proportion_estimation")
```

## Access App

There are two ways to access the app:

  - <https://alexanderjwhite.shinyapps.io/positiveproportion/>
  - from the package (see below)

<!-- end list -->

``` r
run_app()
```

## Instructions

Welcome to the positive rate proportion dashboard. As an example of how
the dashboard works, COVID-19 testing data collected by the city of
Chicago has been pre-loaded. Follow the steps below to estimate the true
positive rate proportion.

1.  Format your data as shown in the image below. The first row should
    contain the column names. Each row in the column named ‘tests’
    should contain the number of tests performed. Each row in the column
    named ‘cases’ should contain the number of positive test results.
    Acceptable formats include .csv, .xlsx, and .xls.

2.  Navigate to the Upload tab.

3.  Select Browse and upload your file.

4.  A table of default positive rate proportion will populate in the
    Results table. Estimate the positive rate proportion for a custom
    range by adjusting the sliding bar and selecting Update.

## Background

The distribution of COVID-19 test positivity rate in communities
(e.g. proportion of communities with test positivity rate below certain
threshold) is critically important to guide public health and policy
responses. If 10 out of 50 zip code areas in a city have a test
positivity rate below 5% then the naïve estimate of the proportion is
\(\frac{10}{50}=0.2\). The naïve estimate, however, ignores the margin
of error of the test positivity rate in each zip code, which could lead
to either over- or under-estimate of the proportion. This online
application uses a statistical method called Bayesian deconvolution to
generate a more accurate estimate.

![](inst/data/figure_1.png)

### Figure 1

Illustration on how the native calculation can result in
overly-optimistic or overly-pessimistic estimate of the proportion of
community-level test positivity rate below a threshold.

### Legend

The figure on the left side shows one scenario where the naïve estimate
will overestimate the proportion of community level test positivity rate
of 5% or less as compared with estimate that accounts for the margin of
errors (adjusted estimate). The red area indicates the magnitude of
over-optimism. The figure on the right side shows one scenario where the
naïve estimate will overestimate the proportion of community level test
positivity rate of 5% or more. The red area indicates the magnitude of
over-pessimism.