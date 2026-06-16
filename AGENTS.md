# AGENTS.md

## Project Purpose

This repository is a PostgreSQL-based SQL portfolio for SQLD study and practical data analysis.

The main goals are:

1. Practice SQLD concepts.
2. Write practical PostgreSQL queries.
3. Build portfolio-ready SQL analysis projects.
4. Keep all work reproducible through SQL files, markdown notes, and Git commits.

## Working Rules

- Do not delete existing SQL files unless explicitly requested.
- Preserve Korean comments written by the user.
- Improve SQL readability using clear indentation.
- Add comments that explain why the query is useful.
- Prefer PostgreSQL syntax.
- When SQLD/Oracle syntax differs from PostgreSQL, explain the difference in markdown.
- Every project should include:
  - schema.sql
  - insert_sample_data.sql
  - analysis_queries.sql
  - insights.md
  - README.md

## SQL Style

- Use uppercase for SQL keywords.
- Use snake_case for table and column names.
- Use table aliases only when they improve readability.
- Add a short comment above each analysis query.

## Portfolio Output Rules

When the user writes rough notes or comments, turn them into:

1. Clean SQL
2. Short explanation
3. Business insight
4. README section
5. Commit-ready file organization

## Review Guidelines

- Check whether queries are executable in PostgreSQL.
- Check whether table and column names match the schema.
- Check whether insights are supported by query results.
- Flag hardcoded assumptions.
- Suggest better indexes only when they are relevant.