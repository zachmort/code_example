## Information about query

This is a query I wrote recently for my company. This has been edited from its original form for privacy reasons.

### Objective of Query:
This query is a scheduled query in BigQuery (also the code is in BigQuery syntax) that runs once a quarter. The objective is to understand the percentage of distinct shoppers that fall into different demographic groups (in this case income ranges) by each vertical. Example: It is useful to know that of all Big_Box shoppers 17% fall into the 15k – 49k range, 24% fall into the 50k – 75k range and so on. This table is pulled into looker dashboard for sales and PR use. The sales team uses this table to talk to clients that have bought into the Demo Breakout package of services. This gives clients insights to see how each vertical differs by demographic breakout and how they (we breakout age, location, family size and more) change over time.

### Table Descriptions:
`Visits_table`: Contains details regarding location pings of each device (visit information essentially) (Example info: Device_id (Primary Key), Chain_id (foreign key), Longitude, Latitude, Time, Chain_name, Time_spent_at_location)
`Demographic_Data`: Contains data pertaining to individual device (user) demographic information e.g. (Device_Id (Primary key), Age, Median_income, Gender)
`Chain_Information`: Contains information on a chain level, (Example: Walmart it will have information on all of its stores e.g. Chain_id (primary key), State, Hours_of_operation, Type_of_store, Vertical_category, Size_of_the_individual_store)

### Table Relationships:
Visits_table -> Demographic_Data is a many to zero relationship (as not all device_ids that we have in the visits table have a matching device_id in the demographic table)
Chain_Information -> Visits_table is a one to many relationship (as we have all information on a per chain_id level (this is distinct) matching to many instances of that chain_id showing up in the visits table)
