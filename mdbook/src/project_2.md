# Project 2 - Driving Business Value with Data Engineering

## Context

#### Data Engineering Project Evaluation Report
<!-- 1200 words -->

The eTenders application was initially designed to eliminate the time wasted reading through 50 emails per day and uses AI to discern which tenders should be responded to.

## S11: [Pass] Demonstrates the use of core technical concepts for digital and technology solutions, including: applies the principles of data analysis for digital and technology solutions

### Evidence

#### Stakeholder Engegement & crafting a solution <!-- 500 words -->

##### Key stakeholders and requirements
<!--
Identify key stakeholders, then gather and prioritise requirements
-->
Key stakeholders are the business leaders responsible for the sales effort in Ireland, the development team who build and deploy internal applications and the support team responsible for ongoing management of their applications.

- **Sales Team**: Focus on usability, visibility, deadline management (core business needs) and winning tenders
- **Development Team**: Emphasis on security, compliance, and authentication (protecting sensitive tender data)
- **Support Team**: Priority on maintainability, alarms, user management, and documentation (keeping the system running smoothly)

<!--
| Stakeholder | Requirements                        | Priority |
|:------------|:-----------------------------------:|---------:|
| Sales Team  | Easy to use, access and update      | High     |
|             | Integrated with Sales Process/CRM   | High     |
|             | Deadline tracking & reminders       | High     |
|             | Tender and Response PDF downloads   | High     |
|             | Search & filtering capabilities *   | Medium   |
|             | Win/loss analysis *                 | Medium   |
|             | Reporting & dashboards              | High     |
|             | Mobile accessibility                | Low      |
| Dev Team    | Scalable                            | Medium   |
|             | Familiar Programming Language       | High     |
|             | Data security & access control      | High     |
|             | GDPR compliance                     | High     |
|             | Backup & disaster recovery          | High     |
|             | API design for integrations         | Medium   |
|             | Database performance optimization   | Medium   |
|             | CI/CD pipeline                      | Medium   |
|             | Infrastructure cost management      | Medium   |
|             | Authentication (SSO/MFA)            | High     |
|             | Audit trails                        | High     |
| Support     | Maintainable                        | High     |
|             | Has logging                         | Medium   |
|             | Alarms when it fails                | High     |
|             | User management & permissions       | High     |
|             | Clear error messages                | Medium   |
|             | Training documentation              | High     |
|             | SLA monitoring                      | Medium   |
|             | Troubleshooting tools               | Medium   |
|             | Backup/restore procedures           | High     |
|             | Usage analytics                     | Low      |
|             | Change management process           | Medium   |
-->

![Requirements](./images/project_2/Requirements.png)
Figure 3: Business and Technical Requirements

##### Research

###### Database Options

By taking the characteristics of the data into account we can rule out certain database types.

It's not streaming, unstructured data so no-sql data types aren't really valuable here. While you could consider each tender record to be a "document" there really isn't the update frequency, scalability issues or fault tolerance requirements because we're dealing with less than 3000 records.

We can use a traditional SQL scheme approach because the structure of the data is well understood, it doesn't change often and we can use traditional backup methods rather than having to worry about scaling or data-replication.

- Database schema for tables is well understood
- Database schema doesn't change frequently
- Updates (writes) are infrequent
- Reads are infrequent
- Total data volume is not large (3000 - 5000 records max)  

What is possibly open for debate is how to load/update and interact with the database. Should it be in the cloud? Which one? Should it be hosted on a server or as a service? Which particular flavour of SQL should we use? Postgresql? Microsoft SQL? We can also use several Azure hosted options (Microsoft.com, 2025)

From talking to Technical & Support stakeholders we do know it needs to interact with Microsoft services (Dynamics 365, Fabric) and potentially run in Azure.

We can look at options with a weighting, including a noSQL option for comparison

| Criteria | Weight | Azure SQL | PostgreSQL | Cosmos DB |
|----------|--------|-----------|------------|-----------|
| Sales (M365) Integration | 25% | 8/10 | 8/10 | 7/10 |
| Team Familiarity | 20% | 8/10 | 9/10 | 4/10 |
| Security & Compliance | 20% | 9/10 | 9/10 | 8/10 |
| Cost (3-5k records) | 15% | 6/10 | 9/10 | 5/10 |
| Scalability | 10% | 8/10 | 8/10 | 10/10 |
| Maintainability | 10% | 9/10 | 8/10 | 7/10 |
| **Weighted Score** | | **8.0** | **8.6** | **6.6** |

Figure 4: SWOT Analysis with Weighting

Analysis shows that Azure hosted PostgreSQL is the preferred option, especially because we can also develop the entire solution using locally hosted PostgreSQL to save time initially.

<!--
Using relevant data analysis techniques
  - analyse stakeholder feedback
  - research and compare potential organisational data solutions

Research and compare potential organisational data solutions to generate ideas for developing a data solution

NOTES:
- weighting vs requirements
- SWOT analyse
- ??

-->

##### Stakeholder feedback

The commerical team needs to focus primarily on business outcomes and getting feedback on the workflow is far easier when it's explained visually:

```mermaid
flowchart TD
    Start([Daily Tender Check]) --> Gather[Gather Tender Records<br/>from eTenders.gov.ie]
    Gather --> PDF[Extract PDF Content<br/>& Metadata]
    PDF --> CPV{Check CPV Codes<br/>Relevant?}
    
    CPV -->|No| Archive[Archive as<br/>Not Relevant]
    CPV -->|Yes| AI[AI/ML Analysis<br/>Score & Recommend]
    
    AI --> Decision{AI Recommendation<br/>Score > Threshold?}
    Decision -->|No| Archive
    Decision -->|Yes| Alert[Alert Sales Team<br/>via Email/Dashboard]
    
    Alert --> Review[Sales Team Review<br/>in Dashboard]
    Review --> Pursue{Pursue<br/>Tender?}
    
    Pursue -->|No| Declined[Mark as Declined<br/>+ Reason]
    Pursue -->|Yes| BidPrep[Prepare Bid Response]
    
    BidPrep --> UploadDoc[Upload Bid Documents<br/>to Database]
    UploadDoc --> Submit[Submit Tender Response]
    
    Submit --> Track[Track Submission<br/>+ Deadline]
    Track --> Outcome[Await Tender Outcome]
    
    Outcome --> Result{Tender<br/>Result?}
    Result -->|Won| Won[Update: Tender WON<br/>+ Contract Value]
    Result -->|Lost| Lost[Update: Tender LOST<br/>+ Competitor Info]
    
    Won --> Analysis[Analysis Dashboard<br/>Win/Loss Analytics]
    Lost --> Analysis
    Declined --> Analysis
    Archive --> Analysis
    
    Analysis --> Feedback[Feedback Loop:<br/>Improve AI Model]
    Feedback --> Templates[Generate Response<br/>Templates from Wins]
    
    Templates -.->|Improve Future Bids| BidPrep
    Feedback -.->|Retrain Model| AI
    
    Analysis --> Reports[Generate Reports:<br/>- Success Rate by CPV<br/>- Competitor Analysis<br/>- Response Template Library]
    
    Reports --> Start

    style Start fill:#e1f5e1
    style Alert fill:#fff3cd
    style Won fill:#d4edda
    style Lost fill:#f8d7da
    style Analysis fill:#d1ecf1
    style Feedback fill:#cce5ff
    style Templates fill:#d4edda
```

Figure 5: Business Process Flow

We should aim to get technical stakeholder buy in through focusing on data-flow, using standardised tools, ease of support, security, logging and maintainability.

```mermaid
graph TB
    subgraph "External Systems"
        ETenders[eTenders.gov.ie<br/>API]
        M365[Microsoft 365<br/>Dynamics 365]
        Email[Email Service<br/>SMTP/Graph API]
    end
    
    subgraph "Azure Cloud Platform"
        subgraph "Application Layer"
            WebApp[Web Dashboard<br/>ASP.NET/Blazor]
            API[REST API<br/>Authenticated]
            Functions[Azure Functions<br/>Scheduled Tasks]
        end
        
        subgraph "Data Layer"
            PostgreSQL[(Azure PostgreSQL<br/>Managed Service)]
            BlobStorage[Blob Storage<br/>PDF Documents]
            AIService[Azure OpenAI<br/>ML Analysis]
        end
        
        subgraph "Security & Monitoring"
            AAD[Azure AD<br/>SSO/MFA]
            KeyVault[Key Vault<br/>Secrets Management]
            Monitor[Application Insights<br/>Logging & Alerts]
            Backup[Automated Backups<br/>Point-in-Time Recovery]
        end
    end
    
    subgraph "CI/CD Pipeline"
        GitHub[GitHub Repo]
        Actions[GitHub Actions]
        Deploy[Azure DevOps]
    end
    
    ETenders -->|HTTPS| Functions
    Functions -->|Write| PostgreSQL
    Functions -->|Store PDFs| BlobStorage
    Functions -->|AI Analysis| AIService
    
    WebApp -->|Auth| AAD
    API -->|Auth| AAD
    WebApp -->|Query| API
    API -->|Read/Write| PostgreSQL
    API -->|Retrieve PDFs| BlobStorage
    
    PostgreSQL -->|Integration| M365
    API -->|Alerts| Email
    
    API -->|Secrets| KeyVault
    Functions -->|Secrets| KeyVault
    
    WebApp -->|Logs| Monitor
    API -->|Logs| Monitor
    Functions -->|Logs| Monitor
    
    PostgreSQL -->|Daily| Backup
    
    GitHub -->|Trigger| Actions
    Actions -->|Build & Test| Deploy
    Deploy -->|Deploy| WebApp
    Deploy -->|Deploy| Functions
    
    style AAD fill:#0078d4
    style Monitor fill:#ff6b6b
    style KeyVault fill:#ffd93d
    style Backup fill:#6bcf7f
    style PostgreSQL fill:#336791
```

Figure 6: Technical Architecture

We're going to take the Python functions used to develop the proof of concept and re-work them into Azure Functions.

We can also use the PostgreSQL database as a back-end for Microsoft Fabric (abnarain, 2025) which will integrate with incoming email updates about tender awards as well as updates from the Sales Team.

<!--
Generate Ideas for developing a data solution, or update to data architecture
Use data viz tools to present insights and gather initial stakeholder feedback
-->

<!--

Demostrate a funcamental understanding of how to implement a data analytics and/or engineering solution to measure and realise value.

RUBRIC - B

Designs and implements a data solution that meets business requirements. Focuses on scalability, performance optimization, security, and regulatory compliance. Conducts comprehensive testing and automation with scheduling.

RUBRIC - A

Designs and implements a sophisticated data solution that meets business requirements. Focuses on scalability, performance optimization, security, and regulatory compliance. Conducts comprehensive testing and automation with scheduling. Includes flexible design for future changes and adherence to best practices.
-->


## K13: [Pass] Demonstrates the use of core technical concepts for digital and technology solutions, including: applies the principles of data analysis for digital and technology solutions

### Evidence

#### Data Product Development <!-- 1000 words -->

<!-- Understand the specific business problem to be addressed -->

We want to build a data product that becomes an invaluable bid preparation, analysis and feedback tool. Something that allows non-technical users to ask questions about the tenders coming out of the Irish Govt, identify tenders that we maybe should of bid for that didn't and ultimately provides a sales feedback loop that drives further commercial successes.

##### Data Pipeline & Data Sources

There are 7 data sources when it comes to updating the database, turning it into the commercial backbone of the Sales Process.

The pipeline contains the traditional Extract, Transform & Load stages BUT in fact it's more in-depth, thanks to the introduction of AI.

1. ETL
   - Scrape (extract)
   - Parse (transform)
   - Load

2. AI Enrichment
   - PDF Parsing with Ollama

3. AI Analysis
   - Bid recommendation with Ollama

4. Business Updates
   - Bid Submission
   - Sales Updates
   - Awards

Although a "load" step exists in the first "ETL" stage we're in fact writing the data to the database (or files) as each step completes.

##### DB Schema & ERD

```mermaid
erDiagram
    ETENDERS_CORE ||--|| ETENDERS_PDF : "has"
    ETENDERS_CORE ||--|| BID_ANALYSIS : "generates"
    ETENDERS_CORE ||--|| CPV_CHECKER : "validates"
    ETENDERS_CORE ||--o{ SALES_UPDATES : "receives"
    ETENDERS_CORE ||--o| BID_SUBMISSION : "submits"
    ETENDERS_CORE ||--|| TENDER_NOTIFICATION : "awarded"
    
    ETENDERS_CORE {
        string resource_id PK
        int row_number
        string title
        string detail_url
        string contracting_authority
        string info
        date date_published
        datetime submission_deadline
        string procedure
        string status
        string notice_pdf_url
        date award_date
        decimal estimated_value
        int cycle
        datetime date_published_parsed
        datetime submission_deadline_parsed
        datetime award_date_parsed
        decimal estimated_value_numeric
        int cycle_numeric
        boolean has_pdf_url
        boolean has_estimated_value
        boolean is_open
    }
    
    ETENDERS_PDF {
        string resource_id PK,FK
        string pdf_url
        boolean pdf_parsed
        text pdf_content_full_text
    }
    
    BID_ANALYSIS {
        string resource_id PK,FK
        boolean should_bid
        decimal confidence
        text reasoning
        text relevant_factors
        decimal estimated_fit
        datetime analyzed_at
    }
    
    CPV_CHECKER {
        string resource_id PK,FK
        int cpv_count
        string cpv_codes
        text cpv_details
        boolean has_validated_cpv
    }
    
    SALES_UPDATES {
        int id PK
        string resource_id FK
        date date
        text sales_comment
        string author
    }
    
    BID_SUBMISSION {
        string resource_id PK,FK
        date submission_date
        string bid_document
        string author
    }
    
    TENDER_NOTIFICATION {
        string resource_id PK,FK
        date notification_date
        string winning_bidder
        text bid_terms
        text award_reasons
    }
```

Figure 7: DB Schema and ERD

The diagram shows:

- **1:1 relationships** between `ETENDERS_CORE` and `ETENDERS_PDF`, `BID_ANALYSIS`, `CPV_CHECKER`, and `TENDER_NOTIFICATION`
- **1:Many** relationship with `SALES_UPDATES` (multiple progress updates per tender)
- **1:0 or 1** relationship with `BID_SUBMISSION` (optional, but max one per tender)

All tables use `resource_id` as the linking key, with `SALES_UPDATES` having its own auto-increment ID as the primary key.

##### Data Product

###### Scalability & Performance

The pipeline adds up to 50 records (maximum) per day and Sales Team members add updates but this isn't anything near enough to stretch PostgreSQL on either scalability or performance.

We've indexed common query patterns (date ranges, status, value), which keeps performance well within acceptable limits. Additional optimization becomes relevant only at 100,000+ records or with real-time requirements - neither applies to our use case.

We are going nowhere _near_ postgresql's limits (www.postgresql.org, n.d)

###### Security

**Who has access?**
Role-Based Access Control (RBAC) splits access into groups and ensure "least privilege" (Microsoft RBAC, 2024)

For example we'd give Sales "read" access to everything but only "write" access to bid submissions fields and Management would get "read all" and so on.

Only authorized individuals have access using Azure AD integration with Single Sign-On (SSO) and mandatory Multi-Factor authentication (najshahid, 2025). Access should be auditable in the logs alongside other database activity.

**Data Protection**
All data should be encrypted at rest and in transit using TLS 1.3 or higher with API keys and secrets held in secure storage like Azure Key Vault with automated key rotation built in.  (msmbaldwin, n.d.)

**Application Security**
Input validation prevents things like SQL injection attacks and XSS (cross site scripting) while rate limiting on any API's prevent miss-use.

**Network Security**
The database should NOT be publically available on the web. If we _do_ happen to need this we should at least enable DDOS protection on any public IP/ports. Use Network Security Groups with a port/source whitelist and also put everything behind a NAT Gateway (asudbring, 2023)

**Compliance & Governance**
Enlist a third party carries out an annual independent security audit and there should be an incident response plan for responding to a possibl data breach.

The data can also be considered as 'internal only' and 'confidential' so this should inform our security architecture.

###### Regulatory Compliance

**GDPR:**
Only the necessary minimum data should be collected and certainly not anything that could be considered personally identifiable information (Wikipedia Contributors, 2019)
We can use AI related services from cloud providers to purge public identifiable information (PII) and have the ability to remove any on request. (laujan, 2025)

**Data Retention and Auditing:**
Monthly point in time recovery with a years backups in archive (to reduce cost).

Activity logging allows auditing of data access requests, logins and even performance behaviour.

**Industry Standards:**
We need to document security controls like ISO 27001 (International Organization for Standardization, 2022) and any cloud compliance certificates i.e. ISO 27018 which is cloud specific (for, 2025)

###### Flexibility for future Use

**MCP Server Integration:**
Model Context Protocol implementation empowers end-users to ask natural language questions of the data, for example: - "Show me all the healthcare tenders over €1m in value in the last 12 months".

This also enables other AI Assistants to return structured responses when they decide to get this data to answer a related question.

**Predictive Analytics and AI:**
Once enough tender and response data exist this can be used in the ML training to return an overall probability of a successful bid based on historical patterns.

Another application might be taking the previously submitted winning bids and having AI produce an auto-generated first draft for new responses that takes context from historical successes.

**Technology Agnostic Design:**
A more generic architectural approach like containerisation (Powell, 2021) might be useful for it's ability to be deployed on any cloud, or on-prem.

This means we won't get painted into a corner when going from building the solution (the Dev part) to deploying and running it i.e. the "Ops" part.

###### Best practices

There are a LOT of sources and influences on best practices when it comes to database design, deployment, software engineering and AI/ML.

**Data Engineering:**
If we're going to host this solution in the cloud (again) we can look at the Microsoft or AWS well architected framework guides (PageWriter-MSFT, 2023) which inform security, reliability, operational scalability and cost-optimisation at the 'cloud' level.

These also link to DevOps practices like deploying everything using infrastructure as code tools (bicep, terraform, pulumi), using version control for scripts, automated testing and CI/CD pipelines.

**Software Development:**
This covers basic things like clean code principles (Codacy, 2023), having meaningful code reviews, deployment gates and adhering to the twelve factor app methodology as much as possible (Wigging, 2017).

**AI/ML best practices:**
We must follow responsible AI principals (mesameki, 2024) with a human in the loop to check any decision making and ensure accountability.

<!--
**References:**
- Azure Architecture Center: Reference architectures for data analytics solutions
- Google SRE Book: Site Reliability Engineering principles
- DAMA-DMBOK: Data Management Body of Knowledge for data governance
- OWASP: Web application security standards and testing guidelines
-->

<!--
● Understand the specific business problems to be addressed and identify all necessary data sources.
● Plan and define the data solution, including any ETL processes or data flows. Consider data formats, sizes, and frequency of updates in the design.
● Choose an appropriate data solution (see list below), focusing on compatibility and scalability. This may be a low-code, no-code, or a coded solution, depending on business needs.
● Develop your data product, conduct comprehensive testing, and automate with scheduling.
● Focus on scalability, performance optimization, security, and regulatory compliance.
● Ensure flexibility for future changes and adherence to best practices.
-->

<!-- Milestone 2
##### Design and develop a scalable, secure ETL pipeline proof of concept that adheres to industry best practices.
  - Stakeholder Identification and Needs Analysis
  - Identify key stakeholders involved in the data engineering process and detail their roles.
  - Conduct a needs analysis based on stakeholder feedback, categorizing primary requirements and challenges.
  - Prioritize these needs in alignment with business goals and outline high-level requirements for a data solution.
##### ETL Process Requirements and Solution Selection
  - Specify the ETL process requirements, focusing on data types, flow frequency, volume, and data quality standards.
  - Compare and evaluate at least two ETL tools or frameworks (e.g., Apache Airflow vs. AWS Glue) for their alignment with organizational requirements.
  - Justify the selection based on criteria like performance, scalability, security, and regulatory compliance.
-->


## S10: [Pass] Demonstrates the use of core technical concepts for digital and technology solutions, including: initiates, designs, implements and debugs a data product for a digital and technology solution

### Evidence

#### Proof of Concept <!-- 500 -->

The revised architecture can be roughed out in a simple proof of concept using Python to capture the eTenders data from the site, parsing the PDF content and have AI split the content of the PDF into additional fields within the pdf_content table.

Before the advent of AI we'd have used Regex for this last step but now that LLM's can output structured data reliably using a locally hosted LLM (possibly running in a container) this is basically free and easy to implement.

Following software development best practice around separation of concerns we can have Python fuctions that carry out discrete steps: -

1. Scrape the data
2. Parse it into the correct type
3. Retreive the PDF content
4. Parse the PDF content using a local LLM
5. Analyse the number of CPVs in the tender
6. Have a local LLM analyse the tender
7. Output the content, store or send it 'somewhere' - options are csv, json or postgres

If we don't know "where" to send the data at this point we could have multiple functions to do step 7 and just vary the "write" parts at the end.

```mermaid
flowchart TD
    A[eTenders Website] -->|Scrape Data| B[Raw Data]
    B -->|Parse & Type Coercion| C[Structured Data]
    C -->|Load to Database| D[(ETENDERS_CORE)]
    D -->|Extract PDF URLs| E[Download PDFs]
    E -->|Parse PDF Content| F[Local LLM Processing]
    F -->|Store PDF Data| G[(ETENDERS_PDF)]
    F -->|Analyze CPV Codes| H[(CPV_CHECKER)]
    F -->|Generate Bid Recommendation| I[(BID_ANALYSIS)]
    
    J[Sales Team] -->|Progress Updates| K[(SALES_UPDATES)]
    L[Sales Team] -->|Bid Submissions| M[(BID_SUBMISSION)]
    N[Irish Government Emails] -->|Tender Status<br/>Won/Lost/Awarded| O[(TENDER_NOTIFICATION)]
    
    D -.->|Links via resource_id| G
    D -.->|Links via resource_id| H
    D -.->|Links via resource_id| I
    D -.->|Links via resource_id| K
    D -.->|Links via resource_id| M
    D -.->|Links via resource_id| O
    
    style A fill:#e1f5ff
    style F fill:#ffe1f5
    style D fill:#e1ffe1
    style G fill:#e1ffe1
    style H fill:#e1ffe1
    style I fill:#e1ffe1
    style K fill:#e1ffe1
    style M fill:#e1ffe1
    style O fill:#e1ffe1
    style J fill:#fff4e1
    style L fill:#fff4e1
    style N fill:#fff4e1
```

Figure 8: Data Pipeline Flow Diagram

The technical aspect of implementing these steps is NOT complicated and doesn't require the use of third party tools. In fact, using Python allows us to really tune the solution to our needs.

##### Testing

Another advantage of writing the data pipeline ourselves is that we can create tests to comprehensively handle each step in the process.

![Test Results](./images/project_2/test_results.png)
Figure 9: Test Results

This encompasses the following: -

- Data structure checks
- Type coercion for dates & currencies
- PDF downloads & validation
- Getting the CPV codes
- Validating the DB schema
- Data integrity and business rules

Being able to check & run these tests on a consistent basis could easily be added to any deployment pipeline too.

The most important (initial) tests make sure that the eTenders data format that's being scraped hasn't been changed by the source. The Irish Govt in this case.

##### Logging & Debugging

We can make sure that each step has proper logging which can be turned on as needed via the `--enable-logging` flag.

The entire data pipeline logs outputs to a file, in this case see ![etenders_20251128_131354.log](https://github.com/robertsweetman/module_4/blob/main/python/etenders_20251128_131354.log) where we can see issues arrise and take measures to fix the pipeline directly.

Building our own data pipeline in code means we can respond flexibly and quickly to issues that arrise.

###### PDF Extraction Errors

About 30% of errors (not records!) are PDF extraction errors.

```log
2025-11-28 14:39:26,109 - pdf_parser - ERROR - Error extracting text from PDF https://www.etenders.gov.ie/epps/cft/downloadNoticeForAdvSearch.do?resourceId=6965752: No /Root object! - Is this really a PDF?
Traceback (most recent call last):
  File "/Users/robert.sweetman/Documents/GitHub/module_4/python/pdf_parser.py", line 54, in extract_pdf_text
    text = extract_text(pdf_file)
  File "/Users/robert.sweetman/Documents/GitHub/module_4/python/venv/lib/python3.9/site-packages/pdfminer/high_level.py", line 177, in extract_text
    for page in PDFPage.get_pages(
  File "/Users/robert.sweetman/Documents/GitHub/module_4/python/venv/lib/python3.9/site-packages/pdfminer/pdfpage.py", line 159, in get_pages
    doc = PDFDocument(parser, password=password, caching=caching)
  File "/Users/robert.sweetman/Documents/GitHub/module_4/python/venv/lib/python3.9/site-packages/pdfminer/pdfdocument.py", line 752, in __init__
    raise PDFSyntaxError("No /Root object! - Is this really a PDF?")
pdfminer.pdfparser.PDFSyntaxError: No /Root object! - Is this really a PDF?
```

Figure 10: PDF Extraction Errors

Some URLs that are in the eTenders data are possibly HTML pages or corrupted. Now that's clear we can add defensive code fixes to the pipeline and improve the logging further.

```python
def download_and_validate_pdf(url):
    try:
        response = requests.get(url, timeout=30)
        
        # Check Content-Type header first
        content_type = response.headers.get('Content-Type', '')
        if 'application/pdf' not in content_type:
            log_error(f"Not a PDF (Content-Type: {content_type})")
            return None
            
        # Validate PDF magic bytes
        if not response.content.startswith(b'%PDF'):
            log_error(f"Invalid PDF format")
            return None
            
        return response.content
    except Exception as e:
        log_error(f"Download failed: {e}")
        return None
```

Figure 11: Python fix for PDF Extraction Errors

###### Server Errors

About 35% of errors involve the server not responding to certain requests.

```log
2025-11-28 14:17:29,640 - pdf_parser - ERROR - Failed to download PDF from https://www.etenders.gov.ie/epps/cft/downloadNoticeForAdvSearch.do?resourceId=7012322: 500 Server Error: Internal Server Error for url: https://www.etenders.gov.ie/epps/cft/downloadNoticeForAdvSearch.do?resourceId=7012322
```

Figure 12: Server Errors

We can add some retry logic to the pipeline to fix this.

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=4, max=60)
)
def download_with_retry(url):
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    return response.content
```

Figure 13: Python Fix for Server Errors

###### LLM JSON parsing errors

The LLM can produce invalid or incomplete JSON

```log
2025-11-28 14:27:26,769 - pdf_parser - ERROR - JSON Parse Error at line 1, column 202: Expecting ',' delimiter
```

Figure 14: JSON Parsing Errors

Again we can add some defensive python coding (REF: defensive coding) to address this by attempting to repair anything that contains this error

```python
def parse_with_llm_robust(text):
    prompt = """Extract structured data as valid JSON. 
    IMPORTANT: Output ONLY complete, valid JSON with all closing braces.
    
    Required fields:
    - procedure_id (string)
    - title (string)
    - buyer_name (string)
    - buyer_country (string)
    - estimated_value (number)
    
    Text to parse:
    {text}
    """
    
    try:
        response = ollama.generate(
            model='llama2',
            prompt=prompt.format(text=text[:4000]),  # Limit input
            format='json'  # Force JSON output
        )
        
        # Validate JSON before returning
        parsed = json.loads(response['response'])
        return parsed
        
    except json.JSONDecodeError as e:
        # Try to salvage partial JSON
        log_error(f"JSON parse error: {e}")
        return attempt_json_repair(response['response'])
```

Figure 15: Python fix for JSON Parsing

###### Timeout Errors

We can see about 10% of errors are due to timeouts getting larger PDF's

```log
2025-11-28 14:11:49,230 - pdf_parser - ERROR - Error parsing with Ollama: HTTPConnectionPool(host='localhost', port=11434): Read timed out. (read timeout=90)
Traceback (most recent call last):
  File "/Users/robert.sweetman/Documents/GitHub/module_4/python/venv/lib/python3.9/site-packages/urllib3/connectionpool.py", line 468, in _make_request
    six.raise_from(e, None)
  File "<string>", line 3, in raise_from
  File "/Users/robert.sweetman/Documents/GitHub/module_4/python/venv/lib/python3.9/site-packages/urllib3/connectionpool.py", line 463, in _make_request
    httplib_response = conn.getresponse()
  File "/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/http/client.py", line 1349, in getresponse
    response.begin()
  File "/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/http/client.py", line 316, in begin
    version, status, reason = self._read_status()
  File "/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/http/client.py", line 277, in _read_status
    line = str(self.fp.readline(_MAXLINE + 1), "iso-8859-1")
  File "/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/socket.py", line 704, in readinto
    return self._sock.recv_into(b)
socket.timeout: timed out
```

Figure 16: Timeout Errors

So we can add a retry queue to address these problems.

```python
class ErrorHandler:
    RETRYABLE = ['500', 'timeout', 'connection']
    SKIP = ['No /Root object', 'JSON Parse Error']
    
    def handle_error(self, error, url):
        if any(e in str(error) for e in self.RETRYABLE):
            # Add to retry queue with backoff
            self.retry_queue.add(url, delay=calculate_backoff())
        else:
            # Log and skip
            self.failed_urls.add(url)
            log_to_csv(url, error, 'SKIPPED')
```

Figure 17: Python fix for Timeout Errors

<!--
Design, implement and debug a data product

RUBRIC - B

Develop a comprehensive data product meeting business requirements, with focus on scalability, performance, security and compliance. Conducts thorough testing and logging

RUBRIC - A

Develops a hightly adaptable, scalable data product exceeding current business needs. Implements a solution with optimized performance and proactive security measures. Provides actionable insights driving business value. Evaluates the use of automation and scheduling
-->


#### Appendix

All python (data-pipeline) code as well as PostrgeSQL setup can be found in [this module 4 repository](https://github.com/robertsweetman/module_4)

```txt
main.py
  │
  ├─> 1. etenders_scraper.py (scrape_pages)
  │   │   └─> Returns generator of raw tender records
  │   │
  │   └─> For each record:
  │       │
  │       ├─> 2. type_coercer.py (coerce_types)
  │       │   └─> Creates tender_record
  │       │
  │       ├─> 3. pdf_parser.py (enrich_record_with_pdf) [if --no-pdfs NOT set]
  │       │   └─> Creates pdf_record
  │       │
  │       ├─> 4. cpv_list_checker.py (check_cpv_codes) [if --no-cpvs NOT set]
  │       │   └─> Creates cpv_record
  │       │
  │       └─> 5. bid_analyzer.py (analyze_tender_for_bid) [if --analyze-bids set]
  │           └─> Creates bid_record
  │
  └─> Output to one of:
      ├─> json_output.py (JSONOutput)
      ├─> csv_output.py (CSVOutput)
      └─> postgres_output.py (PostgresOutput)
```


## K14: [Pass] Explains core technical concepts for digital and technology solutions, including: Data gathering, data management, and data analysis

### Evidence

#### Data Engineering Project Evaluation Report
<!-- 1200 words -->

The eTenders application was initially designed to eliminate the time wasted reading through 50 emails per day and uses AI to discern which tenders should be responded to.

##### Data Management

<!-- The data load of eTenders is currently carried out in a pretty naive fashion. -->

The initial project scope didn't really encompass database design, integration, analysis or ongoing application support.

Storing the eTenders data as rows and then reporting against their status within the processing pipeline was the only consideration in the beginning.

There was no integration with other data sources, the Postgresql database was hosted in AWS RDS (Amazon Web Services, Inc., 2019) to be accessible from the Rust AWS Lambda code and backup provision was minimal.

However to reduce costs it is still open to the web (via username and password) since putting it behind an AWS Nat Gateway (AWS, 2020) to increase security costs an additional £30 per month.

It serves mainly as a state storage device to answer the following questions:

1. Which tenders have already been looked at
2. Where is a particular tender record in the AWS Lambda pipeline process
3. Which tenders have we suggested to the business (via email) should be looked into further

The database of tender records isn't the 'product' in this case. The 'respond to this tender' emails are currently the only product or business value resulting from all this work.

###### Database table design

The existing application uses AWS Lamdba's written in Rust so from a basic data-gathering perspective we can make use of Rust's struct objects. Rust structs (doc.rust-lang.org, n.d.) are essentially custom objects which are the 'record' being moved and modified through the ETL pipeline.

![TenderRecordRaw](./images/project_2/TenderRecordRaw.png)

Figure 1: Raw Tender Record

Initially everything is collected as a String type and then parsed into a more appropriate type.

![TenderRecord](./images/project_2/TenderRecord.png)

Figure 2: Transformed Tender Record

This TenderRecord struct is the base object which is either passed between Lambda's or written to the database. It's not a critical consideration but Rust as a language can perform these sorts of data type changes very quickly. Rust is faster than other languages, with the possible exception of C/C+ (Vietnam Software Outsourcing - MOR Software, 2016).

#### Tender Records Table

Each record is stored in a single row, like an excel spreadsheet. There is a unique resource_id per tender so we can use this as a key for "something" but not very much consideration has been given to how to use this data beyond the Machine Learning (ML) training that was carried out initially. (robertsweetman, 2025)

In a prior ML training phase, once the eTenders table contained enough records, a percentage were manually labelled as 'tenders we should bid on' and then basic linear regression with tokenisation was run against this training data.

Being able to gain other insights from the data wasn't really considered. It's purely been used to reduce Sales admin time & to try to avoid missing any tenders which should be looked at by a human.

#### PDF Content Table

In most cases each tender has an accompanying PDF that contains more information about the bid process for that tender.

These PDF's are not always comprehensive but they do supply the AI analysis step with a lot of valuable context to help decide whether to bid on something or not.

However, from a database point of view, the entire PDF is being stored as a long text string in an accompanying pdf_content column which is linked to the main eTenders table via the resource_id key.

##### Key Findings

From talking to stakeholders there has been some very clear feedback.

Reducing the daily tender analysis time has benefited the sales team but the strictly linear workflow (get, parse, analyse, alert) doesn't really leverage the database to deliver further business value beyond automating this one process.

The business value is actually limited and doesn't justify the application maintenance and support requirements.

This is due to technical challenges in the way this proof-of-concept (POC) has been delivered:

- Runs in AWS, not Azure
  - Version 1's infra runs in Azure so this is a general blocker to wider adoption
  - The support team are not set up to support AWS hosted apps
- Uses Rust for Lambda's
  - Developers aren't familiar with Rust and can't support it properly
- The Postgresql database is still open to the internet for technical and cost reasons
  - This is a significant security issue

The current implementation blocks further integrations with other business processes and tools, both from a commercial and technical point of view.

<!--
Highlight key findings and provide actional recommendations
-->

<!--
Evaluate the current state of data management at your organisation, including data source integration, storage, quality, compliance with GDPR/HIPAA, security, and tool effectiveness.
-->

##### Needs Analysis
<!--
Detail a comprehensive needs analysis highlighting data related needs and pain points
-->
###### Business Needs

The organisation needs to place the tender requests firmly within the whole bid response process loop. All the current solution does is use AI to help guard against losing the signal within the noise of up to 50 requests per day. It doesn't really add value beyond that.

How can we capture the tender requests, filter out the ones we (as an IT Solutions Consultancy) are not interested in and tie the success or failure of a particular bid back to the original tender request?

This requires a much more robust and holistic data solution which can be connected to other parts of the sales effort.

We could update the database with won and lost tenders to help avoid repeating mistakes associated with losing bids. Another example might be updating the bid database with notifications from the Irish Government about who won bids to understand more about our competitors.

If we append what we send in response to tenders that might even allow us to leverage AI to create bid response templates, improve our ML tender analysis solution with actual "won bid" data and be more confident anything our ML/AI highlights will net a positive return on the time investment to respond to a tender request.

###### Technical Needs
<!-- is it POC or PoC -->
The intial POC is hard to manage because it's in both an unfamiliar language and the incorrect cloud environment for the business.

If we are going to host a more robust solution in the cloud then it at least needs to be in Microsoft's Azure.

Our database also needs to be connectable to the wider 'sales process' environment within the organisation. It's no good lobbing this into another proprietary tool that can't connect to.

<!--

Critically evaluate the design and implementation of organisational data architecture against business initiatives

RUBRIC - B

Analyses organisational data architecture, focusing on its alignment with business initiatives. Provides clear and actionable recommendations for improvement.

RUBRIC - A

Critically evaluates organisational data architecture against business initiatives. Provides a comprehensive and strategic set of recommendations for improvement, supported by clear explanations and persuasive rationale.
-->

<!--
#### Milestone 1
  - Complete a detailed evaluation and restructure proposal for an existing database architecture, focusing on ACID principles and stakeholder requirements.

##### Data Architecture Analysis
  - Map out the existing data sources and describe the relationships between them.
  - Evaluate the alignment of the current architecture with ACID principles, scalability, and performance.
  - Identify pain points related to the data architecture, focusing on areas affecting data quality and accessibility.
##### Data Integration Challenges and Solution Proposal
  - Discuss integration challenges (data quality, compliance, security) and their impacts on business operations.
  - Develop a restructuring proposal, prioritizing stakeholder needs and outlining improvements in data flow and quality.
  - Include a brief comparison of two potential architectural solutions or tools, with a focus on security and compliance.

IMPORTANT: Create an ERD in lucidchart
-->

<!-- 
VERY IMPORTANT POINTS FROM REVIEW WITH JOE

1. Where possibe EVALUATE choices against a set of criteria
 - explain
 - analyse
 - pros/cons
 - EVALUATE

2. LO3 is a TRAP 
 - design, implement, DEBUG (examples of how to debug), automation and scheduling 

3. Look at EVERY word in the rubric and make sure it's being covered somehow.
-->


#### Impact Assessment and Recommendations for Rollout <!-- 800 words -->

Let's not forget that SALES generate REVENUE so ultimately our goal and the measure of our success is that we've contributed in a meaningful way to increased billing.

This approach delivers a secure, monitorable and maintainable data product while leaving room for additional features and valuable integrations to other data sources.

##### Business Wins

In addition to the reduction in Sales admin the business can display key business intelligence information from the data.

![eTenders Intelligence Dashboard](./images/project_2/dashboard_main.png)
Figure 18: eTenders Intelligence Dashboard

Shows the number of bids AI has recommended should be responded to, the total value of these bids (€72 million) while making it clear that 85% of tenders that are published aren't worth responding to!

![eTenders Top Opportinities by Value](./images/project_2/dashboard_top_opportunities.png)
Figure 19: eTenders Top Opportunities by Value

Shows the top opportunities by value as well as the overall distribution of AI recommended bids by value. Perhaps un-surprisingly IT consultancy related tenders tend to cluster > €500K range.

Given this visualization business stakeholders should be able to get an 'at a glance' appreciation for the value of pulling this data into a queriable database.

Having Sales Team members append update records to tenders in progress would allow them to monitor additional sales related KPI's and drive sales improvements:

- When was the last time a bid was updated?
- How often are customers contacted?
- Percentage of won/lost bids?
- How long does it take to respond to a tender?
- How many points of contact happen before a bid is won?

All of these metrics get added to the tender records as they progress to help answer the question "What does our process of winning a tender look like?"

As we see from the data, the cost of missing a bid or losing an opportunity is already very high. We can quible over implementation costs but if this effort tips the chance of winning even a portion of the €70 million then it's worth doing.

##### Implementation and Rollout Plan

In order to de-risk the development and deployment of the solution we can take a phased approach

<!-- markdownlint-disable MD033 -->
<style>
  /* Default for dark themes - white text */
  .mermaid text {
    fill: white !important;
  }
  .mermaid .taskText,
  .mermaid .sectionTitle,
  .mermaid .grid text,
  .mermaid .tickText,
  .mermaid .titleText,
  .mermaid .labelText,
  .mermaid .loopText,
  .mermaid .actor text {
    fill: white !important;
  }
  
  /* Handle mdBook light and rust themes - black text */
  html.light .mermaid text,
  html.light .mermaid .taskText,
  html.light .mermaid .sectionTitle,
  html.light .mermaid .grid text,
  html.light .mermaid .tickText,
  html.light .mermaid .titleText,
  html.light .mermaid .labelText,
  html.light .mermaid .loopText,
  html.light .mermaid .actor text,
  html.rust .mermaid text,
  html.rust .mermaid .taskText,
  html.rust .mermaid .sectionTitle,
  html.rust .mermaid .grid text,
  html.rust .mermaid .tickText,
  html.rust .mermaid .titleText,
  html.rust .mermaid .labelText,
  html.rust .mermaid .loopText,
  html.rust .mermaid .actor text {
    fill: black !important;
  }
  
  /* Ensure dark themes have white text */
  html.navy .mermaid text,
  html.navy .mermaid .taskText,
  html.navy .mermaid .sectionTitle,
  html.navy .mermaid .grid text,
  html.navy .mermaid .tickText,
  html.navy .mermaid .titleText,
  html.navy .mermaid .labelText,
  html.navy .mermaid .loopText,
  html.navy .mermaid .actor text,
  html.ayu .mermaid text,
  html.ayu .mermaid .taskText,
  html.ayu .mermaid .sectionTitle,
  html.ayu .mermaid .grid text,
  html.ayu .mermaid .tickText,
  html.ayu .mermaid .titleText,
  html.ayu .mermaid .labelText,
  html.ayu .mermaid .loopText,
  html.ayu .mermaid .actor text,
  html.coal .mermaid text,
  html.coal .mermaid .taskText,
  html.coal .mermaid .sectionTitle,
  html.coal .mermaid .grid text,
  html.coal .mermaid .tickText,
  html.coal .mermaid .titleText,
  html.coal .mermaid .labelText,
  html.coal .mermaid .loopText,
  html.coal .mermaid .actor text {
    fill: white !important;
  }
  
  /* Ensure links and other specific elements have correct colors in light themes */
  html.light .mermaid .flowchart-link,
  html.rust .mermaid .flowchart-link {
    stroke: #333 !important;
  }
  
  /* Ensure links have correct colors in dark themes */
  html.navy .mermaid .flowchart-link,
  html.ayu .mermaid .flowchart-link,
  html.coal .mermaid .flowchart-link {
    stroke: #ccc !important;
  }
  
  /* Additional styles for better visibility in all themes */
  .mermaid .grid path {
    stroke-opacity: 0.5;
  .mermaid .today {
    stroke-width: 2px;
  }
</style>
<!-- markdownlint-enable MD033 -->

```mermaid
gantt
    title Prototype
    dateFormat YYYY-MM-DD
    axisFormat %b '%y
    tickInterval 1month

    section Phase 1: Prototype
    Requirements Gathering :a1, 2025-07-01, 2w
    Prototype              :a2, after a1, 3w
    Stakeholder Review :crit, a3, after a2, 1w
    Go/No-Go Decision       :crit, milestone, a4, after a3, 0d

    section Phase 2: Development & Deployment
    Sprint 1 :a5, after a4, 2w
    Sprint 2 :a6, after a5, 2w
    Container deployment using IAC :a7, after a6, 1w
    Security Audit :crit, a8, after a7, 1w

    section Phase 3: Business Validation
    User Acceptance Testing :a9, after a8, 1w
    User Feedback :a10, after a9, 1w
    Performance Monitoring :a11, after a10, 1w
    Production Live :milestone, after a11, 0d 
```

Figure 20: Phased Delivery Plan

###### Phase 1: Prototype (6w)

The goal is to validate the technical feasibility as well as ensure all stakeholder feedback has been considered. We can use the following KPI's to ensure all the requirements have been met:

- Majority (>80%?) of stakeholders approve moving forwards
- Technically feasible in that eTenders can be obtained, stored and processed
- Prototype can be created with a set of minimum features (MVP)

#### Phase 1: Contingency

If the PoC proves challenging then pivot to using a different datasource, running everything manually for a while or deploying as something other than a container. Azure Functions might be an alternative.

###### Phase 2: Development and Deployment (6w)

Phase 2 goal is to develop and deploy the solution securely in the cloud paying attention to the following measures to validate success:

- Test coverage that ensures code quality
- Successful deployment to the Azure cloud environment
- Resources deployed pass Microsoft's cloud security checks

#### Phase 2: Contingency

Deployment might be delayed to allow security issues to be patched or possibly the run-rate budget might need to increase to include higher cost protections like Nat Gateways and Azure AD for access.

###### Phase 3: Business Validation (3w)

The goal here is to be able to demonstrate business value and validate user adoption in the short term. Longer term measures will only come to light after several bid cycles have been completed.

#### Short term business measures

- High (>80%) uptake of using the tool by the Sales Team
- Reduction in reported sales admin (time) by Sales Team
- User satisfaction survey reports improvement (anonymous Sales Team survey)

#### Long term business measures

- Overall increase in bids won (revenue) over a 6 - 12 month period
- Identify more opportunities to bid on
- Additional features and integrations are requested by the Sales Team as this proves the product is becoming more useful to the business overall
- Additional requests for analytics and dashboards from Sales Management which again shows interest and buy-in

#### Phase 3 Contingency

If users struggle then additional training would have to be considered and for some users to be selected to champion the use of this tool as a replacement for out-dated manual processes. As with all implementations buy in and support from Management is essential for success.

##### Summary

The dashboard clearly shows the value of having a well architected data product that surfaces business value and can drive commercial success.

Taking a phased approach to delivery keeps all contributors on track and leaves scope for further improvements later.

<!--
● Set measurable goals for your data product, aiming for improvements in data processing speed, accuracy, and resource efficiency.
● Monitor improvements in processing time, data quality, resource utilisation, scalability, and error rates.
● Assess impacts on user productivity, business decision-making, cost savings, and revenue. Collect user feedback to gauge satisfaction and ease of use.
● Compile findings into a comprehensive report with visualisations for clarity.
-->

<!--

Develops a value analysis showing the potential impact of a data-driven solution and distinctly justify your approach to stakeholders (K14)

RUBRIC - B

Develops a value analysis that quantifies the potential impact of a data-driven solution across multiple business metrics. Includes thorough analysis of stakeholder needs from key departments. Provides a clear implementation plan with defined milestones.

RUBRIC - A

Develops a multi-faceted value analysis that quantifies short-term and long term impacts of a data-driven solution, including ROI projections. Incorporating analysis of stakeholder needs across all levels of the organisation. Provides a detailed implementation plan with phased rollout strategy, specific KPI's for each phase and contingency plans.

-->


#### References

abnarain (2025). Data source management - Microsoft Fabric. [online] Microsoft.com. Available at: https://learn.microsoft.com/en-us/fabric/data-factory/data-source-management [Accessed 5 Dec. 2025].

‌‌Amazon Web Services, Inc. (2019). Amazon RDS for PostgreSQL – Amazon Web Services (AWS). [online] Available at: https://aws.amazon.com/rds/postgresql/.

asudbring (2023). What is Azure NAT Gateway? [online] learn.microsoft.com. Available at: https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview.

‌AWS (2020). NAT Gateways. [online] Amazon.com. Available at: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html.

Codacy (2023). What Is Clean Code? A Guide to Principles and Best Practices. [online] blog.codacy.com. Available at: https://blog.codacy.com/what-is-clean-code.

doc.rust-lang.org. (n.d.). Defining and Instantiating Structs - The Rust Programming Language. [online] Available at: https://doc.rust-lang.org/book/ch05-01-defining-structs.html.

for, O. (2025). ISO/IEC 27018:2025. [online] ISO. Available at: https://www.iso.org/standard/27018.

International Organization for Standardization (2022). ISO/IEC 27001 standard – information security management systems. [online] ISO. Available at: https://www.iso.org/standard/27001.

laujan (2025). Identify and extract Personally Identifying Information (PII) from text - Foundry Tools. [online] Microsoft.com. Available at: https://learn.microsoft.com/en-us/azure/ai-services/language-service/personally-identifiable-information/how-to/redact-text-pii [Accessed 6 Dec. 2025].

Microsoft (2024). Best practices for Azure RBAC. [online] learn.microsoft.com. Available at: https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices.

‌Microsoft.com. (2025). Managed Databases | Microsoft Azure. [online] Available at: https://azure.microsoft.com/en-us/solutions/databases.

mesameki (2024). What is Responsible AI - Azure Machine Learning. [online] learn.microsoft.com. Available at: https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai?view=azureml-api-2.

msmbaldwin (n.d.). Configure cryptographic key auto-rotation in Azure Key Vault. [online] learn.microsoft.com. Available at: https://learn.microsoft.com/en-us/azure/key-vault/keys/how-to-configure-key-rotation.

najshahid (2025). Plan for mandatory Microsoft Entra multifactor authentication (MFA) - Microsoft Entra ID. [online] Microsoft.com. Available at: https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mandatory-multifactor-authentication?tabs=dotnet.

Wiggins, A. (2017). The Twelve-Factor App. [online] 12factor.net. Available at: https://12factor.net/.

Wikipedia Contributors (2019). General Data Protection Regulation. [online] Wikipedia. Available at: https://en.wikipedia.org/wiki/General_Data_Protection_Regulation.

www.postgresql.org. (n.d.). PostgreSQL: Documentation: 12: Appendix K. PostgreSQL Limits. [online] Available at: https://www.postgresql.org/docs/current/limits.html.

PageWriter-MSFT (2023). How to use the Azure Well-Architected Framework documentation - Microsoft Azure Well-Architected Framework. [online] learn.microsoft.com. Available at: https://learn.microsoft.com/en-us/azure/well-architected/what-is-well-architected-framework.

Powell, R. (2021). Benefits of Containerization. [online] CircleCI. Available at: https://circleci.com/blog/benefits-of-containerization/.

‌robertsweetman (2025). GitHub - robertsweetman/module_2. [online] GitHub. Available at: https://github.com/robertsweetman/module_2.‌

‌Vietnam Software Outsourcing - MOR Software. (2016). MOR SOFTWARE JOINT STOCK COMPANY. [online] Available at: https://morsoftware.com/blog/fastest-programming-languages.
