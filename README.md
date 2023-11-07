# Running SQLite in the browser with sql.js, wasm and Shiny ✨ 

Demonstration on how to use sql.js (a javascript library to run SQLite on the web) with Shiny.

## Background

This simple demonstration works as follows:

1. You upload a .sqlite file 
2. You execute a query

By default a query is loaded so you can inspect the tables in the database. There's a test .sql file (`test_database.sqlite`) that can be used.

Under the hood:

1. Copy .sqlite file to the www folder so the browser can access it
2. Use sql.js to construct a database using that file
3. Use that instance to exeucte queries on and return the results back to shiny

## Issues?

Note that you might need the [latest version](https://github.com/rstudio/httpuv/releases/tag/v1.6.12) of `httpuv`.
