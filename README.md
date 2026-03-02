# Pizza-Hut-Sales-Intelligence-SQL-Business-Analysis
End-to-end SQL business analysis of Pizza Hut sales data using MySQL to generate revenue insights, customer behavior patterns, and operational performance metrics for strategic decision-making.

## Project Overview
This project performs an end-to-end business analysis of Pizza Hut sales data using MySQL Workbench. The objective is to transform raw transactional data into strategic business insights that support decision-making related to revenue optimization, product performance, and demand trends.

The analysis simulates real stakeholder-driven scenarios and answers high-impact business questions using structured SQL queries.

## Business Objectives
  - The analysis focuses on answering stakeholder-level questions such as:
  - What is the total revenue generated?
  - Which categories drive the highest revenue?
  - What is the average number of pizzas ordered per day?
  - Which pizzas contribute the most to total revenue?
  - What is the Month-over-Month revenue growth trend?
  - Are large-sized pizzas generating proportional revenue?
  - Do customers purchase more during weekends?

## Key KPIs Calculated
  - Total Revenue
  - Total Orders
  - Revenue by Category
  - Revenue by Pizza Type
  - Revenue Contribution (%)
  - Cumulative Revenue Trend
  - Month-over-Month Growth
  - Order Frequency by Category
  - Peak Order Hours
  - Weekend vs Weekday Demand

## Analytical Techniques Used
  - This project demonstrates advanced SQL concepts including:
  - Aggregations and Grouping
  - Common Table Expressions (CTEs)
  - Window Functions (SUM() OVER, LAG(), DENSE_RANK())
  - Revenue Contribution Modeling
  - Time-Series Analysis
  - Ranking within Categories
  - Behavioral Order Analysis

## Sample Insights
  - The Classic category generates the highest overall revenue and order frequency, indicating strong mass-market demand.
  - Premium categories like Supreme and Chicken generate higher revenue per order, suggesting stronger pricing power.
  - Revenue growth trends show seasonal and monthly fluctuations requiring strategic monitoring.
  - Evening hours represent peak ordering periods, highlighting operational load concentration.
  - A small number of pizza types contribute a significant portion of total revenue (Pareto effect).

## Tools & Technologies
  - MySQL Workbench
  - SQL (Joins, CTEs, Window Functions)
  - Relational Database Modeling
  - Business KPI Framework

## Dataset:
  - Raw dataset:
      order_details.csv
      orders.csv
      pizzas.csv
      pizza_types.csv
  - SQL file:
      Pizza_hut.sql
              





