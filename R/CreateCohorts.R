# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of RCRI
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.createCohorts <- function(connection,
                           cdmDatabaseSchema,
                           vocabularyDatabaseSchema = cdmDatabaseSchema,
                           cohortDatabaseSchema,
                           cohortTable,
                           oracleTempSchema,
                           outputFolder) {
  
  # Create study cohort table structure:
  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "CreateCohortTable.sql",
                                           packageName = "RCRI",
                                           dbms = attr(connection, "dbms"),
                                           oracleTempSchema = oracleTempSchema,
                                           cohort_database_schema = cohortDatabaseSchema,
                                           cohort_table = cohortTable)
  DatabaseConnector::executeSql(connection, sql, progressBar = FALSE, reportOverallTime = FALSE)
  
  
  
  # Instantiate cohorts:
  pathToCsv <- system.file("settings", "CohortsToCreate.csv", package = "RCRI")
  cohortsToCreate <- utils::read.csv(pathToCsv)
  for (i in 1:nrow(cohortsToCreate)) {
    writeLines(paste("Creating cohort:", cohortsToCreate$name[i]))
    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = paste0(cohortsToCreate$name[i], ".sql"),
                                             packageName = "RCRI",
                                             dbms = attr(connection, "dbms"),
                                             oracleTempSchema = oracleTempSchema,
                                             cdm_database_schema = cdmDatabaseSchema,
                                             vocabulary_database_schema = vocabularyDatabaseSchema,
                                             
                                             target_database_schema = cohortDatabaseSchema,
                                             target_cohort_table = cohortTable,
                                             target_cohort_id = cohortsToCreate$cohortId[i])
    DatabaseConnector::executeSql(connection, sql)
  }
  
  pathToCustom <- system.file("settings", 'CustomCovariates.csv', package = "RCRI")
  if(file.exists(pathToCustom)){
    # if custom cohort covaraites set:
    cohortVarsToCreate <- utils::read.csv(pathToCustom)
    
    if(sum(colnames(cohortVarsToCreate)%in%c('atlasId', 'cohortName'))!=2){
      stop('Issue with cohortVariableSetting - make sure it is NULL or a setting')  
    }
    
    cohortVarsToCreate <- unique(cohortVarsToCreate[,c('atlasId', 'cohortName')])
    for (i in 1:nrow(cohortVarsToCreate)) {
      writeLines(paste("Creating cohort:", cohortVarsToCreate$cohortName[i]))
      sql <- SqlRender::loadRenderTranslateSql(sqlFilename = paste0(cohortVarsToCreate$cohortName[i], ".sql"),
                                               packageName = "RCRI",
                                               dbms = attr(connection, "dbms"),
                                               oracleTempSchema = oracleTempSchema,
                                               cdm_database_schema = cdmDatabaseSchema,
                                               vocabulary_database_schema = vocabularyDatabaseSchema,
                                               
                                               target_database_schema = cohortDatabaseSchema,
                                               target_cohort_table = cohortTable,
                                               target_cohort_id = cohortVarsToCreate$atlasId[i])
      DatabaseConnector::executeSql(connection, sql)
    }
  
  
  }
  
  
  
}
