# WFU Library Research Services Faculty Survey (Public)
Public version of the WFU Faculty Library Research Survey project code from 2025. The original code and output is included, but the original survey data is not available.

## Purpose of the survey
This survey was designed and implemented by the Digital Initiatives and Scholarly Communication (DISC) team at Z. Smith Reynolds Library.

Collaborators included:
- Joddy Marchesoni (author)
- Molly Keener (supervisor and reviewer)
- Kyle Denlinger (colleague and reviewer)

Since Data Services is a new program at ZSR, DISC decided to conduct a survey in Spring 2025 to evaluate faculty research needs.

We designed questions to include every department in the library, focusing primarily on research services. We wanted to discover the tools and kinds of data faculty may need help with, what kind of research they’re doing, how they do their research and the challenges, and what they want to get out of library faculty workshops. At the end, we included free response questions so they could share anything else that would help us better support their research.

The strategic goal addressed by the survey was how to improve research services at ZSR Library, particularly the work of DISC (the new data services, scholarly communication and open access, digital pedagogy, and more). The survey report would ultimately be shared with library leadership on Admin Council (the library dean and the departmental directors) to provide high-level survey results and strategic takeaways from faculty input. This report would aid in decision-making for the library leadership, including the new dean (she started in Summer 2025).

I wrote a [public blog post](https://zsr.wfu.edu/inside/2025/disc-faculty-research-survey-the-results-are-in/) to highlight the results and future directions for the service, as well as internal reports and webpages.

## Conducting the survey in Spring 2025

I (Joddy) created the survey in Qualtrics and worked with Institutional Research to distribute it to all faculty on campus -- every school and division and every status (part-time, full-time, tenured, teaching faculty, etc).

Out of around 1000 faculty who received an invitation, we received 231 responses with 177 complete responses, covering every school on campus.

There were three kinds of questions in the survey:
- quantitative/closed-ended
- qualitative/open-ended
- contact information

## Coding the survey analysis

After receiving survey results, we reviewed the Data & Analysis in the Qualtrics platform. Since we used multiple select questions for software tools questions and other topics, most of the visualizations did not adequately represent the survey results. We also had two major open-ended questions, so qualitative analysis was needed for those.

R is the programming language I am most familiar with, and it is great for working with surveys, so I selected RStudio for the quantitative data analysis, and MaxQDA for the qualitative part. I used the opportunity to refresh my knowledge of R coding, and did not use AI to write any part of the project.

# Overview of the code

## Input and output
Input
- Data from Qualtrics over API
- OR spreadsheet data from previous analysis

Output
- generated HTML report
  - structured in sections
  - visualizations
  - tables
- Spreadsheets for survey data
  - quantitative
  - qualitative
  - contact list
- R data export (entire survey)

## Code files
- faculty_survey.R
  - handles receiving data (from spreadsheet, R data file, or Qualtrics API)
  -  data cleaning 
- wfu_faculty_survey_deid.qmd
