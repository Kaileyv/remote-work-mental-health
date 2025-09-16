# Impact of Remote Work on Mental Health
An analysis of the impact of remote work on the mental health of individuals across various professions, using SQL for data cleaning and analysis as well as Tableau for building a dashboard to identify trends and outliers.

## Table of Contents
* [About the Project](https://github.com/Kaileyv/remote-work-mental-health/tree/main?tab=readme-ov-file#about-the-project)
* [Data Source](https://github.com/Kaileyv/remote-work-mental-health/tree/main?tab=readme-ov-file#data-source)
* [Tools Used](https://github.com/Kaileyv/remote-work-mental-health/tree/main?tab=readme-ov-file#tools-used)
* [Project Structure](https://github.com/Kaileyv/remote-work-mental-health/tree/main?tab=readme-ov-file#project-structure)
* [Tableau Dashboard](https://github.com/Kaileyv/remote-work-mental-health/tree/main?tab=readme-ov-file#tableau-dashboard)
* [Key Insights](https://github.com/Kaileyv/remote-work-mental-health/tree/main?tab=readme-ov-file#key-insights)

## About the Project
This project explores the impact of remote work on mental health by analyzing factors such as professional experience, workload, stress levels, resources, and mental health conditions of remote workers. The aim is to identify patterns and correlations that reveal how different factors of remote work influence the well-being of individuals, helping inform strategies to support healthier remote work environments.

## Data Source
The data was sourced from Kaggle.com and contains:
* Impact_of_Remote_Work_on_Mental_Health.csv

## Tools Used
* **SQL (MySQL)** - Performed data cleaning, complex querying using Common Table Expressions (CTEs), table joins, and aggregations to extract and structure insights
* **Tableau** - Designed dashboard and conveyed insights through visual storytelling

## Project Structure
```
global-tech-layoffs/
│
├── data/                
│   └── Impact_of_Remote_Work_on_Mental_Health.csv              # Original dataset
│
├── sql/                  
│   └── remote_work_mental_health.sql                           # SQL cleaning and queries  
│
├── tableau/               
│   └── Remote Work Mental Health.twbx                          # Tableau dashboard
│
└── README.md                                                   # Project overview
```
## Tableau Dashboard
[View Tableau Dashboard](https://public.tableau.com/views/RemoteWorkMentalHealth_17579593786790/hor_Dashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![](https://github.com/Kaileyv/remote-work-mental-health/blob/main/remote_work_mental_health_dashboard.png)

## Key Insights
* The _**industry**_ with the most mental health conditions for remote workers globally is _**IT**_. Whereas, the _**industry**_ with the least mental health conditions for remote workers globally is _**Finance**_
* The _**job role**_ with the most mental health conditions for remote workers globally is _**Data Scientist**_. Whereas, the _**job role**_ with the least mental health conditions for remote workers globally is _**Marketing**_
* The continent with the most mental health conditinos for remote workers is _**Europe**_. Whereas, the continent with the least mental health conditinos for remote workers is _**North America**_
* _**Anxiety**_ is the most common mental health condition, while _**depression**_ is the least common mental health condition
