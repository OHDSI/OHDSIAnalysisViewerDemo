---
editor_options: 
  markdown: 
    wrap: 72
---

# OHDSI Analysis Viewer Demo (2024)

This repo holds the Docker container that provides the OHDSI Shiny
Results Viewer for the 2024 OHDSI Symposium OHDSI Analysis Viewer Demo.

The results viewer for the demo can be found here: [
](https://results.ohdsi.org/app/22_ohdsi_analysis_viewer_app_demo)

## Overview

The development of robust, standardized tools that allow users to
interactively explore data is an important consideration when
considering the evolving landscape of observational health data
analytics and large-scale epidemiology research. The OHDSI community has
spearheaded the development of numerous open-source packages, primarily
through the Health Analytics Data-to-Evidence Suite (HADES), which
collectively empower researchers to conduct comprehensive observational
studies1-4 . Despite their efficacy, these tools previously operated in
silos, requiring separate installations and producing disparate outputs.
Last year's introduction of the OHDSI Analysis Viewer aimed to
consolidate these tools into a unified interface. Building on that
foundation, this year's enhancements have significantly improved
performance, stability, and both the user experience (UX) and user
interface (UI), further integrating cutting-edge tools and refining the
platform’s capabilities.

This year's software demo uses an exercise from the Book of OHDSI,
described
[here](https://ohdsi.github.io/TheBookOfOhdsi/PopulationLevelEstimation.html#problem-definition-2).

The problem definition is:

> "What is the risk of gastrointestinal (GI) bleed in new users of
> celecoxib compared to new users of dicloflenac?"

Answering this question primarily revolves around conducting a
population-level effect estimation (PLE) analysis. However, to fully
demonstrate the power and new updates to the OHDSI Analysis Viewer, all
possible modules were included in the application, which include: \

-   About

-   DataSources

-   Cohorts

-   CohortDiagnostics

-   Characterization

-   Prediction

-   Estimation

-   Report

### Study Specifications

Below are the high-level study specifications used in the demo:

**Target (T):** celecoxib

**Comparator (C):** dicloflenac

**Indication (I):** N/A

**Outcome (O):** GI Bleed

Per the example in the Book of OHDSI, "The ingedient concept IDs for
celecoxib and dicloflenac are 1118084 and 1124300, respectively.
Time-at-risk starts on day of treatment initiation, and stops at the end
of observation (a so-called intent-to-treat analysis". There were 3 data
sources that were included in this particular example: (1) France
Disease Analyzer, (2) German Disease Analyzer, and (3) Merative
MarketScan®️ Multi-State Medicaid Database.

## Usage

This README assumes you are familiar with Docker concepts. An overview
of Docker can be found
[here](https://docs.docker.com/guides/docker-overview/).

Since this container is designed to work with the OHDSI Shiny Proxy
Deploy, it will require some modifications if you'd like to use it on
your machine. Here are the steps if you'd like to try it out:

-   Clone this repository
-   Add a file called `.env` to the root of the project to hold
    sensitive information. Specifically, you'll want to add your [GitHub
    Personal Access
    Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
    to the `.env` file so it looks like this:

``` bash
build_github_pat="ghp_<secret>"
```

-   Edit `app.R` to include the details to connect to your database.
    Specifically this section:

``` r
cli::cli_h1("Starting shiny server")
serverStr <- paste0(Sys.getenv("shinydbServer"), "/", Sys.getenv("shinydbDatabase"))
cli::cli_alert_info("Connecting to {serverStr}")
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = serverStr,
  port = Sys.getenv("shinydbPort"),
  user = "shinyproxy",
  password = Sys.getenv("shinydbPw")
)


cli::cli_h2("Loading schema")
ShinyAppBuilder::createShinyApp(
   config = shinyConfig,
   connectionDetails = connectionDetails,
   resultDatabaseSettings = createDefaultResultDatabaseSettings(schema = "viewerdemo2024"),
   title = "OHDSI Analysis Viewer Demo (2024)"
)
```

In the code above, you'll want to replace the
`DatabaseConnector::createConnectionDetails` with the details to connect
to your PostgreSQL database with the study results. Additionally, you'll
want to change the `schema` parameter in:
`resultDatabaseSettings = createDefaultResultDatabaseSettings(schema = "viewerdemo2024")`
to match the schema where you have the study results.

-   Once the changes above are complete, you can build the container by
    running:

`docker-compose build`

-   Once the docker container is built, you can run it:

`docker-compose up`

The application will be available on <http://localhost:3838>
