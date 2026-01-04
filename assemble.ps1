# Read all source files
$file1 = Get-Content "c:\Users\rober\GitHub\module_4_temp\mdbook\src\1_current_state.md" -Raw
$file2 = Get-Content "c:\Users\rober\GitHub\module_4_temp\mdbook\src\2_stakeholder_engagement.md" -Raw
$file3 = Get-Content "c:\Users\rober\GitHub\module_4_temp\mdbook\src\3_data_product.md" -Raw
$file4 = Get-Content "c:\Users\rober\GitHub\module_4_temp\mdbook\src\4_poc.md" -Raw
$file5 = Get-Content "c:\Users\rober\GitHub\module_4_temp\mdbook\src\5_impact_assessment.md" -Raw

# Build complete project_2.md
$output = @"
# Project 2 - Driving Business Value with Data Engineering

## Context

The eTenders application was initially designed to eliminate the time wasted reading through 50 emails per day and uses AI to discern which tenders should be responded to. The initial project scope didn't really encompass database design, integration, analysis or ongoing application support. However, from talking to stakeholders there has been some very clear feedback - the business value is actually limited and doesn't justify the application maintenance and support requirements.

This project evaluates the current state of data management for the eTenders application, identifies key stakeholder requirements, and proposes a comprehensive data engineering solution that firmly places tender requests within the whole bid response process loop. The goal is to capture tender requests, filter out irrelevant ones, and tie the success or failure of particular bids back to the original tender request - ultimately driving increased revenue through better data-driven decision making.

---

$file2

---

$file1

$file3

---

$file4

---

$file5

"@

# Save to file
$output | Out-File -FilePath "c:\Users\rober\GitHub\portfolio\mdbook\src\project_2_assembled.md" -Encoding UTF8 -NoNewline
$lineCount = ($output -split "`n").Count
Write-Output "File created with $lineCount lines"
