library(OhdsiShinyModules)
library(ShinyAppBuilder)

shinyConfig <- initializeModuleConfig() |>
  addModuleConfig(
    createDefaultAboutConfig()
  )  |>
  addModuleConfig(
    createDefaultDatasourcesConfig()
  )  |>
  addModuleConfig(
    createDefaultCohortGeneratorConfig()
  ) |>
  addModuleConfig(
    createDefaultCohortDiagnosticsConfig()
  ) |>
  addModuleConfig(
    createDefaultCharacterizationConfig()
  ) |>
  addModuleConfig(
    createDefaultPredictionConfig()
  ) |>
  addModuleConfig(
    createDefaultEstimationConfig()
  ) |> 
  addModuleConfig(
    createDefaultReportConfig()
  )



cli::cli_h1("Starting shiny server")
serverStr <- paste0(Sys.getenv("shinydbServer"), "/", Sys.getenv("shinydbDatabase"))
cli::cli_alert_info("Connecting to {serverStr}")
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = serverStr, #Sys.getenv("shinydbServer"),
  port = Sys.getenv("shinydbPort"),
  user = "shinyproxy",
  password = Sys.getenv("shinydbPw")
)

cli::cli_h2("Loading schema")
createShinyApp(
  config = shinyConfig,
  connectionDetails = connectionDetails,
  resultDatabaseSettings = createDefaultResultDatabaseSettings(schema = "viewerdemo2024"),
  title = "OHDSI Analysis Viewer Demo (2024)",
  studyDescription = "This is a software demonstration for the 2024 OHDSI Analysis Viewer. In this sample study,
  we investigate the risk of gastrointestinal (GI) bleed in new users of celecoxib compared to new users of dicloflenac."
)