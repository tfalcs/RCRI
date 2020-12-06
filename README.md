RCRI model validation study
=============

<img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started"> 

- Analytics use case(s): **Patient-Level Prediction**
- Study type: **Clinical Application**
- Tags: **OHDSI 2020 Study-a-thon**
- Study lead: **Jenna Reps, Peter Rijnbeek**
- Study lead forums tag: **[jreps](https://forums.ohdsi.org/u/jreps), [Rijnbeek](https://forums.ohdsi.org/u/Rijnbeek)**
- Study start date: **2020-10-01**
- Study end date: **2020-11-01**
- Protocol: **Coming Soon**
- Publications: **Coming Soon**
- Results explorer: **Coming Soon**

The objective of this study is to preform a large-scale external validation of the RCRI prognostic model across the OHDSI network using OMOP CDM data

Instructions To Install and Run Package From Github
===================

- Make sure you have PatientLevelPrediction installed:

```r
  # get the latest PatientLevelPrediction
  install.packages("devtools")
  devtools::install_github("OHDSI/PatientLevelPrediction", ref = 'development')
  # check the package
  PatientLevelPrediction::checkPlpInstallation()
```

- Then install the study package:
```r
  # install the network package
  devtools::install_github("ohdsi-studies/RCRI")
```

- Execute the study by running the code in (extras/CodeToRun.R) but make sure to edit the settings:
```r
library(RCRI)
# USER INPUTS
#=======================

# The folder where the study intermediate and result files will be written:
outputFolder <- "./RCRIResults"

# Details for connecting to the server:
dbms <- "you dbms"
user <- 'your username'
pw <- 'your password'
server <- 'your server'
port <- 'your port'

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- 'cdm database schema'
cdmDatabaseName <- 'A friendly name for the database name'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'RCRICohort'

# TAR settings
sampleSize <- NULL
riskWindowStart <- 1
startAnchor <- 'cohort start'
riskWindowEnd <- 2*365
endAnchor <- 'cohort start'
firstExposureOnly <- F
removeSubjectsWithPriorOutcome <- T
priorOutcomeLookback <- 99999
requireTimeAtRisk <- F
minTimeAtRisk <- 1
includeAllOutcomes <- T


#=======================

RCRI::execute(connectionDetails = connectionDetails,
                         cdmDatabaseSchema = cdmDatabaseSchema,
                         cdmDatabaseName = cdmDatabaseName,
                         cohortDatabaseSchema = cohortDatabaseSchema,
                         cohortTable = cohortTable,
                         setting = data.frame(tId = rep(c(18947, 18948),2), 
                                                        oId = c(rep(18935,2),rep(18949,2)), 
                                                        model = c('rcri_with_creatinine_model.csv',
                                                                      'rcri_with_creatinine_plus_renal_model.csv',
                                                                      'rcri_with_creatinine_model.csv',
                                                                      'rcri_with_creatinine_plus_renal_model.csv')
                         ),
                         sampleSize = sampleSize, 
                         recalibrate = T,
                         riskWindowStart = riskWindowStart,
                         startAnchor = startAnchor,
                         riskWindowEnd = riskWindowEnd,
                         endAnchor = endAnchor,
                         firstExposureOnly = firstExposureOnly,
                         removeSubjectsWithPriorOutcome = removeSubjectsWithPriorOutcome,
                         priorOutcomeLookback = priorOutcomeLookback,
                         requireTimeAtRisk = requireTimeAtRisk,
                         minTimeAtRisk = minTimeAtRisk,
                         includeAllOutcomes = includeAllOutcomes,
                         outputFolder = outputFolder,
                         createCohorts = T,
                         runAnalyses = T,
                         viewShiny = T,
                         packageResults = T, 
                         minCellCount= 5,
                         verbosity = "INFO",
                         cdmVersion = 5)
```
# Development status
Under development.

