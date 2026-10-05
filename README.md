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
### faculty_survey.R
faculty_survey.R imports and processes the survey data, creating a set of
spreadsheets for the 3 survey data types (quantitative, qualitative, contact).
Quantitative and qualitative survey data was transformed for table and chart
presentation. 
The final output includes a full export of all the data in a single R data file.

Output data from this code will be imported by the rendering code
(wfu_faculty_survey_deid.qmd and the other renderers). There are multiple
rendering targets - admin (all data), stakeholders (all data except open-ended
responses), public (only aggregated data). This allows creating output webpages 
for each privilege level separately from the cleaning and processing.

#### Code purpose and outputs
  - handles receiving data (from spreadsheet, R data file, or Qualtrics API)
  - data cleaning
    - rename questions to human-readable names
    - set college division levels to human-readable
    - recode multiple select questions to be boolean (TRUE/FALSE)
    - transform the survey from wide format to long format (for the visualizations)
    - qualitative cleaning - transform for MaxQDA input
    - contact list cleaning - de-duplicate and create human-readable columns for the contact list
    - export all survey data to an R data file
    - export individual datasets (quant, qual, contact list) to Excel files
    
### wfu_faculty_survey_deid.qmd

This code is an example renderer, although it will not work without valid survey 
data. A .qmd file is a Quarto file -- it allows the programmer to write code in 
"chunks" and render it to a PDF, HTML file, or many other formats. I chose HTML 
since the data would be shared internally on the ZSR web server.

In the original code project, there are renderers for all three targets (admin,
stakeholders, public). For the public version, the data was not available, so 
the report was rendered in the original project using the public, de-identified 
data. Then the final render was copied over to the public project. It is 
identical to the public version without *any* individual level open-ended 
responses. This was required to respect the survey consent level.

#### Code purpose and outputs
The code builds a report consisting of structured, formatted text, tables, and 
charts. The code imports the processed survey data, defines functions for 
creating tables and charts (treemap and bar), and styles the tables and charts. 

The report generated from these elements includes a table and visualization for 
every survey question, with a summary of the open-ended questions at the end. 
The public report was used to create the public blog post, although the report 
itself is not hosted anywhere online currently.

The output is an HTML file containing the report content, and a folder for the 
chart images. It can be uploaded to a web server and displayed in a web browser.

## Reports

The original project included a report for Admin Council, Stakeholders, and Public.

### Admin Council report

Contains individual-level open-ended data and aggregated quantitative data. Google 
Docs with strategic takeaways and next steps for the research services were 
included. I met with Admin Council and led the meeting to go over the report, 
including answering questions and interpreting the results. This meeting served 
to share the survey results (which had questions involving every department), as
well as lay out my department's plan for my first year as Data Services Librarian.

The consent statement for the survey included a section on sharing the responses 
with library leadership, so we were able to respectfully share all individual 
responses (without directly identifying any participants, since the survey was 
anonymous).

### Stakeholder report

The stakeholder report was for the Provost's Office, as well as research librarians 
and liaison librarians. It did not have the takeaways and next steps documents, 
but had all the data from the survey. A summary section was included for the 
open-ended responses.

This report did not have consent to share individual open-ended responses, but 
did have the "Other" responses for the tools used, repositories used, etc.

### Public report

The public report was not posted anywhere on the internet, but the HTML file was
generated for it. The public reporting of the survey is on the blog, which has 
the high-level takeaways and a few charts. A fully de-identified version of this 
report is included in this repository in the "render" folder. It can be opened 
in a local web browser after the project is downloaded.
