##Operator Market Share by Total Capacity##

SELECT operator,
       SUM(charging_capacity_kw * number_of_chargers) AS total_capacity_kw
FROM detailed_ev_charging_stations
GROUP BY operator
ORDER BY total_capacity_kw DESC;

##Fast Charger Percentage per Operator#

SELECT operator,
       ROUND(
           SUM(CASE WHEN charging_capacity_kw > 50 THEN 1 ELSE 0 END)
           * 100.0 / COUNT(*),
       2) AS fast_charger_percentage
FROM detailed_ev_charging_stations
GROUP BY operator
ORDER BY fast_charger_percentage DESC;

##top 5 most profitable stations##

SELECT station_id, operator,
(avg_users_per_day * cost_per_kwh * charging_capacity_kw) 
AS estimated_daily_revenue
FROM detailed_ev_charging_stations
ORDER BY estimated_daily_revenue DESC
LIMIT 5;

##Operator Market Share by Total Capacity##

SELECT operator,
       SUM(total_station_capacity) AS total_capacity
FROM detailed_ev_charging_stations
GROUP BY operator
ORDER BY total_capacity DESC;

#Year-wise Installation Trend#

SELECT installation_year,
COUNT(*) AS total_stations
FROM detailed_ev_charging_stations
GROUP BY installation_year
ORDER BY installation_year;

#High Usage but Low Rating (Risk Detection)#

SELECT station_id,
       avg_users_per_day,
       rating
FROM detailed_ev_charging_stations
WHERE avg_users_per_day >
      (SELECT AVG(avg_users_per_day)
       FROM detailed_ev_charging_stations)
AND rating <
      (SELECT AVG(rating)
       FROM detailed_ev_charging_stations);
       
##Renewable vs Non-Renewable Average Rating##

SELECT renewable_source,
       ROUND(AVG(rating),2) AS avg_rating
FROM detailed_ev_charging_stations
GROUP BY renewable_source;

##Distance Impact on Usage##

SELECT 
    CASE 
        WHEN distance_to_city_km < 5 THEN 'Urban'
        WHEN distance_to_city_km BETWEEN 5 AND 20 THEN 'Semi-Urban'
        ELSE 'Highway'
    END AS location_category,
    ROUND(AVG(avg_users_per_day),2) AS avg_usage
FROM detailed_ev_charging_stations
GROUP BY location_category;

##Most Efficient Operators (Revenue per Charger)##

SELECT operator,
       ROUND(
           AVG((avg_users_per_day * cost_per_kwh * charging_capacity_kw)
               / number_of_chargers),
       2) AS avg_revenue_per_charger
FROM detailed_ev_charging_stations
GROUP BY operator
ORDER BY avg_revenue_per_charger DESC;

##Stations With High Capacity but Low Usage##

SELECT Station_ID,
       charging_capacity_kw,
       avg_users_per_day
FROM detailed_ev_charging_stations
WHERE charging_capacity_kw >
      (SELECT AVG(charging_capacity_kw)
       FROM detailed_ev_charging_stations)
AND avg_users_per_day <
      (SELECT AVG(avg_users_per_day)
       FROM detailed_ev_charging_stations);






