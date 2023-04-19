{{ dbt_utils.date_spine(
    datepart="day",
    start_date="'2016-09-01'",
    end_date="CURRENT_DATE()"
   )
}}
