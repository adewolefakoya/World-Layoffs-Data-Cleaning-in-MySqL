# [Project Title]
> *One sentence. What did you analyze, build, or solve - and why does it matter?*

---

## ⚙️ Project Type Flags
> *Check what applies. This helps reviewers and collaborators understand the nature of the work at a glance. Delete this block before publishing.*

- [ ] Exploratory Data Analysis (EDA)
- [ ] SQL Analysis / Querying
- [ ] Dashboard / Data Visualization
- [ ] Data Pipeline / ETL
- [ ] Predictive Modelling / Machine Learning
- [ ] Data Cleaning / Wrangling
- [ ] End-to-End (multiple of the above)
- [ ] Other: ___________

---

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [Objectives](#2-objectives)
3. [Project Scope & Tools](#3-project-scope--tools)
5. [Data Workflow](#5-data-workflow)
6. [Data Model & Schema](#6-data-model--schema)
7. [ERD - Entity Relationship Diagram](#7-erd--entity-relationship-diagram) *(SQL projects)*
8. [Analysis & Metrics](#8-analysis--metrics)
9. [Key Insights](#9-key-insights)
10. [Recommendations](#10-recommendations)
11. [Assumptions & Limitations](#11-assumptions--limitations)
14. [Author](#14-author)

---

## 1. Project Overview

**Context:**
This project was created to practice cleaning and preparing a real-world layoffs dataset for analysis. The raw dataset contained inconsistencies such as duplicate records, inconsistent naming, missing values, incorrect formatting, and unnecessary records. Before using the data for exploratory analysis, I needed to make sure it was as consistent and reliable as possible.

**Approach**
I imported the raw layoffs dataset into MySQL and created a separate staging table so the original data remained untouched. I then worked through the data systematically by removing duplicates, standardizing inconsistent values, handling missing information, converting data types, and removing records and columns that were not useful for the planned analysis.
Outcome:

**Problem Statement:**
How can I transform a messy global layoffs dataset into a clean, structured dataset that can be confidently used for exploratory data analysis and visualization?

**Outcome:** 
I produced a cleaned and analysis-ready layoffs dataset. The project also gave me practical experience with SQL techniques such as ROW_NUMBER(), CTEs, JOINs, UPDATE, DELETE, TRIM(), STR_TO_DATE(), and ALTER TABLE, while following a workflow that reflects how data cleaning can be handled in a real analytics environment.
---

## 2. Objectives

**Primary Objective**
Clean and standardize the global layoffs dataset so it can be reliably used for exploratory data analysis.

**Secondary Objective 1**
Identify and remove duplicate records without modifying the original raw dataset.

**Secondary Objective 2**
Standardize inconsistent values, missing fields, text formatting, and date formats to improve data quality.

**Secondary Objective 3**
Remove unusable records and temporary fields that could negatively affect future analysis.
Every analysis decision in this project traces back to one of these objectives.

---

## 3. Project Scope & Tools

### Scope

| Dimension | Details |
|-----------|---------|
| **In Scope** | Global layoffs dataset containing company, location, industry, layoffs, percentage laid off, date, stage, country, and funds raised |
| **Out of Scope** | External datasets not included in the original source |
| **Time Period** | Layoff records covering approximately 2020–2023 based on the source dataset |
| **Granularity** | Individual layoff record / row-level data |

### Tools & Technologies

| Category | Tool(s) Used |
|----------|-------------|
| Data Storage | MySql |
| Data Processing |MySQL |
| Analysis | SQL queries |
| Version Control | GitHub |
| Documentation | Markdown / Project documentation |
| Other |MySQL Workbench |

---

## 5. Data Workflow

1. **Source:**
   The project used a real-world global layoffs dataset provided as a CSV file. The dataset contained approximately 2,361 records before cleaning and included information about companies, locations, industries, layoffs, dates, company stages, countries, and funding.
   
2. **Ingestion:**
   The CSV file was imported into MySQL using the MySQL Workbench Table Data Import Wizard. The raw data was preserved in its original form, and a separate staging table was created for the cleaning process.
This was an intentional choice because modifying raw data directly is risky. Keeping a raw copy made it possible to recover the original data if a transformation caused an unexpected result.

3. **Cleaning:**
   Several data-quality issues were identified and addressed:
Duplicate records were identified using ROW_NUMBER() and PARTITION BY.
Extra whitespace was removed from company names using TRIM().
Inconsistent industry labels such as different variations of cryptocurrency-related categories were standardized to Crypto.
Incorrect country formatting, such as United States., was corrected.
Blank industry values were converted to NULL for consistency.
Where possible, missing industry values were populated by matching the same company and location to another record containing the industry.
Text-based dates were converted into proper date values using STR_TO_DATE().
Records with both total_laid_off and percentage_laid_off missing were removed because they provided very limited value for the planned analysis.
A temporary row_num field used for duplicate detection was removed after the cleaning process.

4. **Transformation:**
    The main transformations focused on making existing data more consistent rather than creating complex new metrics.
Key transformations included:
Creating staging tables for safe data manipulation.
Creating a temporary row_num field for duplicate identification.
Converting date text into a proper MySQL DATE data type.
Standardizing categorical values.
Filling selected missing industry values using a self-join.
Removing temporary columns after they were no longer required.

5. **Output:**
     The final output was a cleaned staging table containing standardized, analysis-ready layoffs data. This dataset is intended to serve as the foundation for the next stage of the project: exploratory data analysis and visualization.

---

## 6. Data Model & Schema

<!--
  Define your fields so that someone reading your analysis can follow along
  without digging through your code.

 Field Name
Data Type
Description
Example Value
company
VARCHAR / Text
Name of the company affected by layoffs
Airbnb
location
VARCHAR / Text
Location associated with the layoff
San Francisco
industry
VARCHAR / Text
Industry or business sector of the company
Travel
total_laid_off
INT
Number of employees laid off
300

DECIMAL / Float
Percentage of the workforce laid off
0.10
date
DATE
Date the layoff was recorded
2023-01-15
stage
VARCHAR / Text
Funding or company stage
Series B
country
VARCHAR / Text
Country associated with the company
United States
funds_raised_millions
DECIMAL / Float
Total funding raised by the company in millions

### Dataset / Table: `[name]`

| Field Name | Data Type | Description | Example Value |
|------------|-----------|-------------|---------------|
| `Company` | VARCHAR  / Text | Name of the company affected by layoffs | Airbnb |
| `Location` | VARCHAR  / Text | Location associated with the layoff | Ibadan |
| `Industry` | VARCHAR  / Text | Industry or business sector of the company | Travel |
| `total_laid_off` | INT  | Numbers of employee laid off | 300 |
| `percentage_laid_off` | Decimal  / Float | Percentage of the workforce laid off | 0.10 |
| `date` | Date |Date the layoff was recorded | 2023-01-15 |
| `stage` | VARCHAR  / Text | Funding or company stage | Series B |
| `country` |  VARCHAR  / Text | Country associated with the company | Brazil |
| `funds_raised_millions` | Decimal  / Float | Total funding raised by the company in millions | 500 |

Approximate initial row count: 2,361 records
Date range: Approximately 2020–2023
Key relationship: No relational joins were required because the project was based primarily on a single layoffs dataset. A self-join on company and location was used during cleaning to populate missing industry values.

---

## 7. ERD - Entity Relationship Diagram
### *(Primarily for SQL Projects - remove this section if not applicable)*

<!--
  An ERD shows how your tables connect to each other visually.
  It is the fastest way for a reviewer to understand the data structure
  of a SQL project without reading every query.

  HOW TO INCLUDE YOUR ERD:
  Option A - Image embed (most common):
    Export your ERD from dbdiagram.io, DBeaver, Lucidchart, or similar.
    Save to /visuals/erd.png and reference it below.

  Option B - dbdiagram.io code block (version-controllable):
    Paste your schema definition code directly in the fenced block below.
    Anyone can paste it into dbdiagram.io to regenerate the visual.

  Option C - Mermaid diagram (renders natively in GitHub):
    Use the mermaid code block syntax below.
    GitHub will render this as a diagram automatically.

  PICK ONE. Don't use all three. Delete the options you don't use.
-->

### Option A - Embedded Image
![ERD Diagram](visuals/erd.png)
*[Brief caption: e.g., "Three-table schema - orders, customers, and products joined on shared IDs."]*

---

### Option B - dbdiagram.io Schema Definition
```
Table orders {
  order_id    int     [pk]
  customer_id int     [ref: > customers.customer_id]
  product_id  int     [ref: > products.product_id]
  order_date  date
  amount      float
}

Table customers {
  customer_id int  [pk]
  region_code string
  signup_date date
}

Table products {
  product_id   int    [pk]
  category     string
  unit_price   float
}
```
*Paste this into [dbdiagram.io](https://dbdiagram.io) to view the visual.*

---

### Option C - Mermaid Diagram *(renders on GitHub)*
```mermaid
erDiagram
    ORDERS {
        int order_id PK
        int customer_id FK
        int product_id FK
        date order_date
        float amount
    }
    CUSTOMERS {
        int customer_id PK
        string region_code
        date signup_date
    }
    PRODUCTS {
        int product_id PK
        string category
        float unit_price
    }
    ORDERS ||--o{ CUSTOMERS : "placed by"
    ORDERS ||--o{ PRODUCTS : "contains"
```

---

**Table Relationships Summary:**

| Relationship | Join Key | Type |
|-------------|----------|------|
| `orders` → `customers` | `customer_id` | Many-to-One |
| `orders` → `products` | `product_id` | Many-to-One |
| [Add rows as needed] | | |

---

## 8. Analysis & Metrics

<!--
  Explain what you measured and how - before you share what you found.

  WHAT GOOD LOOKS LIKE:
  Metric: "Customer Return Rate"
  Definition: "Number of transactions flagged as returns divided by total
               transactions, calculated at product-category and regional grain."
  Why It Matters: "Return rate - not sales volume - was hypothesised to
                  explain regional revenue gaps. This metric tests that hypothesis."

  WHAT TO AVOID:
  ❌ Defining a metric only in code: SUM(returns) / COUNT(transaction_id)
     That's an implementation. Write the plain-language definition here.
     Both belong in your project - the definition in the README,
     the implementation in the code.
-->

### Analytical Approach

[Describe how you approached the analysis. Were you exploring patterns? Testing a hypothesis? Building and validating a pipeline? Be honest about your method - exploratory work is valid, just call it that.]

### Key Metrics Defined

| Metric | Plain-Language Definition | Why It Matters |
|--------|--------------------------|----------------|
| `[Metric 1]` | [What it measures, in one sentence] | [What decision or question it answers] |
| `[Metric 2]` | [What it measures, in one sentence] | [What decision or question it answers] |
| `[Metric 3]` | [What it measures, in one sentence] | [What decision or question it answers] |

### Methods Used

- [e.g., Descriptive statistics - distribution, central tendency, outlier detection]
- [e.g., Trend analysis across [time period]]
- [e.g., Segmentation / group comparison by [dimension]]
- [e.g., Correlation analysis between [variable A] and [variable B]]
- [e.g., SQL window functions for [specific aggregation]]
- [e.g., Custom aggregation or transformation logic in [tool]]

---

## 9. Key Insights

<!--
  Findings + implications. Not just what happened - what it means.

  WHAT GOOD LOOKS LIKE:
  ✅ "Return rates, not sales volume, explain Region A's underperformance.
      Region A's return rate on home goods was 34% - more than double the
      company average. Revenue was not lost at the point of sale; it was
      lost post-sale through refunds. This points to a fulfilment or
      product quality issue specific to that region, not a demand problem."

  WHAT TO AVOID:
  ❌ "Region A had lower revenue than other regions in Q4."
     (That's an observation. It describes what happened.
      An insight says what it means and where to look next.)

  Aim for 3–6 insights. Quality over quantity.
-->

**Insight 1: [Short descriptive headline]**
[What you found + what it suggests. One short paragraph.]

**Insight 2: [Short descriptive headline]**
[What you found + what it suggests.]

**Insight 3: [Short descriptive headline]**
[What you found + what it suggests.]

**Insight 4 (if applicable): [Short descriptive headline]**
[What you found + what it suggests.]

---

## 10. Recommendations

<!--
  Action-oriented. Addressed to a real audience.
  Tied explicitly to the insight that supports each one.

  WHAT GOOD LOOKS LIKE:
  Priority: High
  Recommendation: "Conduct a fulfilment audit for home goods deliveries
                   in Region A - specifically investigating whether returns
                   correlate with a particular warehouse, carrier, or SKU batch."
  Based On: Insight 1 - return rate anomaly in Region A
  Owner: Operations / Supply Chain team

  WHAT TO AVOID:
  ❌ "Improve the return rate."
     (Not actionable. Doesn't say who, how, or where to start.)
  ❌ "Further analysis is needed."
     (This is a placeholder, not a recommendation.)
-->

| Priority | Recommendation | Based On | Suggested Owner |
|----------|---------------|----------|-----------------|
| High | [Specific, actionable step] | [Insight it comes from] | [Who should act] |
| Medium | [Specific, actionable step] | [Insight it comes from] | [Who should act] |
| Low | [Exploratory or longer-term suggestion] | [Insight it comes from] | [Who should act] |

---

## 11. Assumptions & Limitations

<!--
  WHAT GOOD LOOKS LIKE:
  Assumption: "Transaction records were assumed to be complete for all five regions.
               No validation was performed against source system record counts."
  Limitation: "The analysis cannot distinguish between returns initiated by
               the customer vs. returns initiated by the business (e.g., recalls).
               If business-initiated returns are concentrated in Region A, the
               return rate finding may reflect a policy decision, not a quality issue."

  WHAT TO AVOID:
  ❌ Leaving this section blank or writing "None known."
     Every project has limitations. Documenting them is a sign of
     analytical maturity - not a confession of failure.
-->

### Assumptions
- [What did you treat as true without being able to verify?]
- [What simplifications did you make for scope or feasibility?]
- [What domain rules or definitions did you accept as given?]

### Limitations
- [What gaps exist in the data?]
- [What analysis was out of scope but could affect interpretation?]
- [What would a more rigorous version of this project include?]
- [Are there known biases in the data source or collection method?]

> *The goal here is pre-emptive Q&A. What would a thoughtful skeptic push back on? Document the answer here, before they ask.*

---

## 13. Deliverables

| Deliverable | Description | Location |
|-------------|-------------|----------|
| [Name] | [What it contains] | [`/path/to/file`] |
| [Name] | [What it contains] | [`/path/to/file`] |
| [Name] | [What it contains] | [`/path/to/file`] |

---

## 14. Author

**[Your Name]**
[Your role or title - current or target]

- 🔗 [LinkedIn URL]
- 💼 [Portfolio or GitHub profile URL]
- 📧 [Email - optional]

---

*Last updated: [Month YYYY]*
*If this template helped you, consider starring the repository.*
