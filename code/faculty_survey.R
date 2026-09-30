# Wake Forest University Faculty Research Survey 2025

## Load libraries --------------------------------------------------------------
library(qualtRics)
library(tidyverse)
library(dplyr)
library(writexl)
library(sjlabelled)
library(janitor)
library(stringr)

## Import data -----------------------------------------------------------------

# Qualtrics API token: [redacted]
qualtrics_base_url <- "wakeforest.qualtrics.com"
qualtrics_api_key <- ""

# NOTE: Once survey is done, no longer need to import the data.
# Can use the static saved .RData file instead.
if(file.exists("full_survey.RData")) {
  # Load the static survey input file
  load("full_survey.RData")
} else {
  qualtrics_api_credentials(api_key = qualtrics_api_key, 
                            base_url = qualtrics_base_url,
                            install = TRUE,
                            overwrite = TRUE)
  readRenviron("~/.Renviron")
  
  surveys <- all_surveys()
  full_survey <- fetch_survey(surveyID = surveys$id[1], unanswer_recode = -99)
}

## Clean data setup-------------------------------------------------------------

# Clean the variable names with janitor, remove unnecessary variables
faculty_survey <- full_survey %>% clean_names() %>% rename_with(
  stringr::str_replace,
  pattern = "(q\\d+)_",
  replacement = "\\1.",
  matches("(q\\d+)_")) %>% select(
    c(response_id, finished, starts_with("q")))
quant_survey <- faculty_survey %>% select(1:2, !ends_with("_text"), -c(q8, q29, q23, q31.156, q25, q26, q27))
qual_survey <- faculty_survey %>% select(1, ends_with("_text"), c(q8, q29, q23, q31.156))
contact_list <- faculty_survey %>% select(q25, q26, q27) %>% filter(q27 != "-99")

## Quantitative data cleaning --------------------------------------------
# Focus on the quantitative data, since we separated qualitative and contact data

# Run if you get an error, could add handling in here)
# detach("package:plyr", unload=TRUE)

### Rename questions to human-readable column names ------------------------------
quant_survey$q3 <- as.factor(quant_survey$q3)
quant_survey$q31.12 <- as.factor(quant_survey$q31.12)
quant_survey$q5 <- as.factor(quant_survey$q5)
quant_survey <- quant_survey %>% rename(
  faculty.body = q3,
  faculty.position = q31.12,
  faculty.served = q5,
  submit.repo = q15,
  funders.require_dmp = q7,
  workshop.modality = q28,
  research.empirical = q11.1,
  research.theoretical = q11.2,
  research.qual = q11.3,
  research.quant = q11.4,
  research.humanities = q11.5,
  research.computational = q11.6,
  research.interdisciplinary = q11.7,
  research.evidence_synthesis = q11.8,
  research.creative = q11.9,
  research.applied_trans = q11.10,
  research.not_sure = q11.11,
  tools.adobe = q10.1,
  tools.ai = q10.2,
  tools.arcgis = q10.3,
  tools.covidence = q10.4,
  tools.dropbox = q10.5,
  tools.github = q10.6,
  tools.google = q10.7,
  tools.icloud = q10.8,
  tools.jmp = q10.9,
  tools.latex = q10.10,
  tools.mathematica = q10.11,
  tools.maple = q10.12,
  tools.matlab = q10.13,
  tools.maxqda = q10.14,
  tools.office = q10.15,
  tools.nvivo = q10.16,
  tools.osf = q10.17,
  tools.python = q10.18,
  tools.qualtrics = q10.19,
  tools.r = q10.20,
  tools.sas = q10.21,
  tools.spss = q10.22,
  tools.stata = q10.23,
  tools.zotero = q10.24,
  tools.other = q10.25,
  collect.audio = q12.1,
  collect.docs = q12.2,
  collect.geo = q12.3,
  collect.images = q12.4,
  collect.interviews = q12.5,
  collect.numeric = q12.6,
  collect.surveys = q12.7,
  collect.text = q12.8,
  collect.other = q12.9,
  create.apps = q13.1,
  create.audio = q13.2,
  create.charts = q13.3,
  create.code = q13.4,
  create.databases = q13.5,
  create.docs = q13.6,
  create.images = q13.7,
  create.spreadsheets = q13.8,
  create.video = q13.9,
  create.visualizations = q13.10,
  create.other = q13.11,
  store.aws = q14.1,
  store.box = q14.2,
  store.dropbox = q14.3,
  store.icloud = q14.4,
  store.github = q14.5,
  store.gdrive = q14.6,
  store.ms365 = q14.7,
  store.osf = q14.8,
  store.personal_pc = q14.9,
  store.personal_server = q14.10,
  store.removable = q14.11,
  store.wfu_pc = q14.12,
  store.wfu_server = q14.13,
  store.other = q14.14,
  repo.arxiv = q16.1,
  repo.dryad = q16.2,
  repo.dataone = q16.3,
  repo.dataverse = q16.4,
  repo.figshare = q16.5,
  repo.icpsr = q16.6,
  repo.osf = q16.7,
  repo.ssrn = q16.8,
  repo.wakespace = q16.9,
  repo.other = q16.10,
  concerns.backup = q17.1,
  concerns.long_term_access = q17.2,
  concerns.repo = q17.3,
  concerns.organization = q17.4,
  concerns.access_data = q17.5,
  concerns.access_pub = q17.6,
  concerns.other = q17.7,
  proc.lib_resources = q18.1,
  proc.digital_archive_resources = q18.2,
  proc.print_archive_resources = q18.3,
  proc.locate_data = q18.4,
  proc.citations = q18.5,
  proc.copyright = q18.6,
  proc.oa = q18.7,
  proc.irb = q18.8,
  proc.new_tools = q18.9,
  proc.data_mgmt = q18.10,
  proc.data_analysis = q18.11,
  proc.collab_tools = q18.12,
  proc.research_impact = q18.13,
  proc.other = q18.14,
  funding.fed_grants = q6.1,
  funding.wfu = q6.2,
  funding.private = q6.3,
  funding.self = q6.4,
  funding.other = q6.5,
  funding.none = q6.6,
  resources.funding_agency = q9.1,
  resources.dmp_tutorial = q9.2,
  resources.orsp = q9.3,
  resources.zsr = q9.4,
  resources.other = q9.5,
  resources.no_dmsp = q9.6,
  lib.workshops = q19.1,
  lib.schol_consult = q19.2,
  lib.copyright_consult = q19.3,
  lib.data_consult = q19.4,
  lib.digitization_lab = q19.5,
  lib.research_consult = q19.6,
  lib.purchase_request = q19.7,
  lib.archives_ref = q19.8,
  lib.ill = q19.9,
  lib.wakespace_repo = q19.10,
  lib.spaces = q19.11,
  lib.other = q19.12,
  workshops.copyright = q20.1,
  workshops.oa = q20.2,
  workshops.archival_research = q20.3,
  workshops.primary_sources_classroom = q20.4,
  workshops.info_lit_classroom = q20.5,
  workshops.data_lit_classroom = q20.6,
  workshops.web_design = q20.7,
  workshops.dh = q20.8,
  workshops.data_mgmt = q20.9,
  workshops.data_analysis = q20.10,
  workshops.gis = q20.11,
  workshops.data_viz = q20.12,
  workshops.other = q20.13,
  w_timing.before_mid_break = q21.1,
  w_timing.after_mid_break = q21.2,
  w_timing.not_first_last_2_wks = q21.3,
  w_timing.summer = q21.4,
  w_timing.anytime = q21.5,
  w_timing.other = q21.6,
  w_time_day.morning = q22.1,
  w_time_day.lunch = q22.2,
  w_time_day.early_afternoon = q22.3,
  w_time_day.late_afternoon = q22.4,
  w_time_day.anytime = q22.5
)

### Set college division levels to human-readable --------------------------------
library(plyr)
quant_survey$faculty.body <- revalue(
  quant_survey$faculty.body,
  c("College Division I" = "I: Humanities",
    "College Division II" = "II: Literatures",
    "College Division III" = "III: Fine Arts",
    "College Division IV" = "IV: Social Sciences",
    "College Division V" = "V: Math and Natural Sciences") )

### Switch out plyr for dplyr (they conflict) ------------------------------------
detach("package:plyr", unload=TRUE)
library(dplyr)

### Put the non-prefixed variables at the beginning of the data frame ----------
quant_survey <- quant_survey %>% select(response_id, finished, faculty.body, faculty.position, faculty.served,
  submit.repo, funders.require_dmp, workshop.modality, starts_with("research") |
    starts_with("tools") |
    starts_with("collect") |
    starts_with("create") |
    starts_with("store") |
    starts_with("repo") |
    starts_with("concerns") |
    starts_with("proc") |
    starts_with("funding") |
    starts_with("resources") |
    starts_with("lib") |
    starts_with("workshops") |
    starts_with("w_timing") |
    starts_with("w_time_day"))

### Recode multiple selection questions ----------------------------------------
# Assign TRUE if the user selected something
# Assign FALSE if the answer was skipped
# Leave as NA if the user didn't see the question at all
quant_survey <- quant_survey %>% mutate(across(
  starts_with("research") |
    starts_with("tools") |
    starts_with("collect") |
    starts_with("create") |
    starts_with("store") |
    starts_with("repo") |
    starts_with("concerns") |
    starts_with("proc") |
    starts_with("funding") |
    starts_with("resources") |
    starts_with("lib") |
    starts_with("workshops") |
    starts_with("w_timing") |
    starts_with("w_time_day"),
  ~ { ifelse(.x == "-99", FALSE, ifelse(!is.na(.x), TRUE, NA)) }))

### Transform the survey data to long format -----------------------------------
# The tables and charts need long format to work properly
quant_survey_long <- quant_survey %>% pivot_longer(
  cols = starts_with("research") |
    starts_with("tools") |
    starts_with("collect") |
    starts_with("create") |
    starts_with("store") |
    starts_with("repo") |
    starts_with("concerns") |
    starts_with("proc") |
    starts_with("funding") |
    starts_with("resources") |
    starts_with("lib") |
    starts_with("workshops") |
    starts_with("w_timing") |
    starts_with("w_time_day"),
  names_sep = "\\.",
  names_to = c("question", "item"),
  values_to = c("selected")
)

# Sort by the levels in the final dataset, will ensure tables and charts are sorted
quant_survey_long$question <- factor(quant_survey_long$question, levels=sort(unique(quant_survey_long$question)))
quant_survey_long$item <- factor(quant_survey_long$item, levels=sort(unique(quant_survey_long$item)))
quant_survey_long <-quant_survey_long %>% arrange(question,item)

# Keep the TRUE rows for the plots (missing data can cause issues)
plot_survey <- quant_survey_long %>% filter(selected == TRUE)
plot_survey <- plot_survey %>% select(-selected)

## Rename long format item levels to human-readable names ----------------------
library(forcats)
levels(plot_survey$item) <- fct_recode(levels(plot_survey$item),
          "Providing online access to my datasets" = "access_data",
          "Providing online access to my publications" = "access_pub",
          "Adobe suite" = "adobe",
          "After mid-semester break" = "after_mid_break",
          "AI chatbots or assistants" = "ai",
          "Anytime" = "anytime",
          "Applied or translational" = "applied_trans",
          "Apps" = "apps",
          "ArcGIS" = "arcgis",
          "Archival" = "archival_research",
          "Special Collections and Archives reference materials" = "archives_ref",
          "Arxiv" = "arxiv",
          "Audio" = "audio",
          "Amazon Web Services" = "aws",
          "Backing up my digital files" = "backup",
          "Before mid-semester break" = "before_mid_break",
          "Box" = "box",
          "Charts" = "charts",
          "Managing bibliographic citations" = "citations",
          "Code" = "code",
          "Digital tools for collaboration" = "collab_tools",
          "Computational" = "computational",
          "Copyright" = "copyright",
          "Copyright consults" = "copyright_consult",
          "Covidence" = "covidence",
          "Creative or practice-based" = "creative",
          "Data analysis" = "data_analysis",
          "Data consults" = "data_consult",
          "Data literacy in the classroom" = "data_lit_classroom",
          "Data management" = "data_mgmt",
          "Data visualization" = "data_viz",
          "Databases" = "databases",
          "DataOne" = "dataone",
          "Dataverse" = "dataverse",
          "Digital humanities" = "dh",
          "Locating digital resources in archives and special collections" = "digital_archive_resources",
          "Digitization lab services" = "digitization_lab",
          "Data management planning tutorials" = "dmp_tutorial",
          "Documents" = "docs",
          "Dropbox" = "dropbox",
          "Dryad" = "dryad",
          "Early afternoon" = "early_afternoon",
          "Empirical" = "empirical",
          "Evidence synthesis" = "evidence_synthesis",
          "Federal grants" = "fed_grants",
          "Figshare" = "figshare",
          "Guidance from the grant funding agency" = "funding_agency",
          "Google Drive" = "gdrive",
          "Geospatial" = "geo",
          "GIS" = "gis",
          "Github" = "github",
          "Google Suite" = "google",
          "Humanities" = "humanities",
          "iCloud" = "icloud",
          "ICPSR" = "icpsr",
          "Inter-library loan" = "ill",
          "Images" = "images",
          "Information literacy in the classroom" = "info_lit_classroom",
          "Interdisciplinary" = "interdisciplinary",
          "Interviews" = "interviews",
          "IRB" = "irb",
          "JMP" = "jmp",
          "Late afternoon" = "late_afternoon",
          "Latex" = "latex",
          "Locating library resources" = "lib_resources",
          "Locating datasets" = "locate_data",
          "Ensuring long-term access to my original data" = "long_term_access",
          "Lunch" = "lunch",
          "Maple" = "maple",
          "Mathematica" = "mathematica",
          "MATLAB" = "matlab",
          "MaxQDA" = "maxqda",
          "Morning" = "morning",
          "Microsoft Office 365" = "ms365",
          "Identifying new digital scholarship tools" = "new_tools",
          "I have not created a DMSP" = "no_dmsp",
          "None" = "none",
          "Not the first or last 2 weeks of the semester" = "not_first_last_2_wks",
          "Not sure" = "not_sure",
          "Numeric" = "numeric",
          "NVivo" = "nvivo",
          "Open access" = "oa",
          "Microsoft Office" = "office",
          "Organizing my research data" = "organization",
          "ORSP" = "orsp",
          "Open Science Foundation" = "osf",
          "Other" = "other",
          "Personal PC or laptop" = "personal_pc",
          "Personal server" = "personal_server",
          "Primary sources in the classroom" = "primary_sources_classroom",
          "Locating print materials in archives and special collections" = "print_archive_resources",
          "Private grants" = "private",
          "Books or materials purchase request" = "purchase_request",
          "Python" = "python",
          "Qualitative" = "qual",
          "Qualtrics" = "qualtrics",
          "Quantitative" = "quant",
          "R" = "r",
          "Portable storage" = "removable",
          "Finding the right repository" = "repo",
          "Research consults" = "research_consult",
          "Research impact" = "research_impact",
          "SAS" = "sas",
          "Digital scholarship consults" = "schol_consult",
          "Self-funded" = "self",
          "Using group study spaces" = "spaces",
          "Spreadsheets" = "spreadsheets",
          "SPSS" = "spss",
          "SSRN" = "ssrn",
          "Stata" = "stata",
          "Summer" = "summer",
          "Surveys" = "surveys",
          "Text" = "text",
          "Theoretical" = "theoretical",
          "Video" = "video",
          "Visualizations" = "visualizations",
          "WakeSpace" = "wakespace",
          "WakeSpace digital repository" = "wakespace_repo",
          "Web design" = "web_design",
          "WFU funding" = "wfu",
          "WFU PC or laptop" = "wfu_pc",
          "WFU server" = "wfu_server",
          "Workshops" = "workshops",
          "Zotero" = "zotero",
          "ZSR Library" = "zsr")

# Manually change levels for the 2 yes/no questions
levels(quant_survey$submit.repo) <- fct_recode(levels(plot_survey$submit.repo),
  "Yes" = "Yes", "No" = "No", "Not sure" = "Not sure (please explain)"
)

levels(quant_survey$funders.require_dmp) <- fct_recode(levels(plot_survey$funders.require_dmp),
  "Yes" = "Yes", "No" = "No", "Not sure" = "Not sure (please explain)"
)
## Qual survey cleaning --------------------------------------------------------
### Rename questions to human-readable column names ----------------------------
qual_survey <- qual_survey %>% rename(
  "faculty_position_other" = q31.5_text,
  "research_type_other" = q11.11_text,
  "tools_other" = q10.25_text,
  "collect_other" = q12.9_text,
  "create_other" = q13.11_text,
  "store_other" = q14.14_text,
  "submit_repo_other" = q15.3_text,
  "repos_other" = q16.10_text,
  "concerns_other" = q17.7_text,
  "proc_other" = q18.14_text,
  "funding_type_other" = q6.5_text,
  "dmsp_required_not_sure" = q7.3_text,
  "resources_other" = q9.5_text,
  "lib_other" = q19.12_text,
  "workshops_other" = q20.13_text,
  "workshop_timing_other" = q21.6_text,
  "funding_agencies" = q8,
  "prevented_attending_w" = q29,
  "additional_comments" = q23,
  "new_developments" = q31.156,
)

### Get rid of empty rows and consolidate responses ----------------------------
qual_survey <- qual_survey %>% mutate(across(
  ,
  ~ { ifelse(.x == "-99", NA, ifelse(!is.na(.x), .x, NA)) }))
qual_survey <- qual_survey %>% select(-faculty_position_other)

### Convert qual survey to long format -----------------------------------------
qual_survey_long <- qual_survey %>% pivot_longer(cols = !response_id, names_to = "question", values_to = "response")
qual_survey_long <- qual_survey_long %>% filter(!is.na(response)) %>% arrange(question)

### Transforming qual surveys for admin and stakeholders -----------------------
### Export long format survey for admin (all comments included)
# Save all comments out to a file to put in summary doc
write_xlsx(qual_survey_long %>% select(-response_id), "comments_for_admin.xlsx")

### Stakeholder transformation
# This was done by looking at column numbers and slicing them out individually
qual_survey_long <- qual_survey_long %>% slice(-c(
  2,3,9,14,20,29,32,36,37,38,46,54,57,61,131,133,144,194,220,236,
  282,283,290,291,292,294,295,296,297,298,300,301,302,303,304,305,307
  ))

# Wide survey for MaxQDA
# Create vectors for each question, then write them out to excel
qual_survey_wide <- qual_survey_long %>% pivot_wider(
  id_cols = response_id,
  names_from = question,
  values_from = response
  
)

# Transpose the data to put the questions on the x axis
# This is for MaxQDA import
qual_survey_final <- as_tibble(cbind(nms = names(qual_survey_wide), t(qual_survey_wide)))

names(qual_survey_final) <- qual_survey_final[1,]
qual_survey_final <- qual_survey_final %>% slice(-1)
names(qual_survey_final)[1] <- "question"

## Contact list cleaning -------------------------------------------------------
# Get the contacts
contact_list <- distinct(contact_list)
# Rename questions to be human-readable
contact_list <- contact_list %>% rename(
  "First" = q25,
  "Last" = q26,
  "Email" = q27
)

## Export all survey data in RData format --------------------------------------
save(faculty_survey, quant_survey, qual_survey, contact_list, quant_survey_long,
     qual_survey_long, plot_survey,
     file = "survey.RData")
save(full_survey, file = "full_survey.RData")

## Export qual datasets to Excel -----------------------------------------------
write_xlsx(contact_list, "contact_list.xlsx")
write_xlsx(qual_survey_final, "qual_survey.xlsx")
