# Technical Documentation & Reproduction Guide

## Environment
- **Database:** MySQL 8.0+
- **Tooling:** Tableau Desktop / Public for Visualizations
- **Dataset:** Olist Brazilian E-Commerce (Kaggle)

## Data Architecture
The analysis relies on the relational integrity between `orders`, `order_items`, `products`, and `order_reviews`. 

## How to Run the Analysis
1. **Schema Setup:** Load the Olist dataset into your MySQL instance.
2. **Execution Order:**
    - Run `sql-queries/01_punctuality_illusion.sql` first to establish the baseline performance.
    - Execute regional queries to populate geospatial dashboards.
3. **Validation:** Compare SQL outputs with the logic documented in the [Executive Summary](./Strategic_Audit_Eniac_Magist.pdf).

## Quality Assurance
All queries have been audited for:
- Null-handling in delivery dates.
- Exclusion of canceled orders to prevent skewing satisfaction scores.
- Standardized currency conversion where applicable.
