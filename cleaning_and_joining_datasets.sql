  -- The following cleaning and joining steps were carried out in Google BigQuery using SQL

  -- 1) Cleaning Cats and Dogs Dataset

  -- Raw data is two tables, one for cats, one for dogs, containing columns for postcode and average number of cats/dogs per household

  -- First checking primary keys and nulls

  -- Cats dataset, PostcodeDistrict is primary key, no nulls

SELECT
  PostcodeDistrict,
  COUNT(PostcodeDistrict) AS count_postcode
FROM
  `raw_data.cats_per_household`
GROUP BY
  PostcodeDistrict
HAVING
  count_postcode > 1
  OR count_postcode IS NULL;

  -- CatsPerHousehold no nulls

SELECT
  CatsPerHousehold
FROM
  `raw_data.cats_per_household`
WHERE
  CatsPerHousehold IS NULL;

  -- ordering by nb of cats per household - same highest 10 as in dogs data

SELECT
  *
FROM
  `raw_data.cats_per_household`
ORDER BY
  CatsPerHousehold DESC;

  -- Dogs dataset, PostcodeDistrict is primary key, no nulls

SELECT
  PostcodeDistrict,
  COUNT(PostcodeDistrict) AS count_postcode
FROM
  `raw_data.dogs_per_household`
GROUP BY
  PostcodeDistrict
HAVING
  count_postcode > 1
  OR count_postcode IS NULL;

  -- DogsPerHousehold no nulls

SELECT
  DogsPerHousehold
FROM
  `raw_data.dogs_per_household`
WHERE
  DogsPerHousehold IS NULL;

  -- ordering by nb of dogs per household - same highest 10 as in cats data

SELECT
  *
FROM
  `raw_data.dogs_per_household`
ORDER BY
  DogsPerHousehold DESC;

  -- joining cats and dogs tables

SELECT
  dogs.PostcodeDistrict,
  dogs.DogsPerHousehold,
  cats.CatsPerHousehold
FROM
  `raw_data.dogs_per_household` AS dogs
LEFT JOIN
  `raw_data.cats_per_household` AS cats
USING
  (PostcodeDistrict);

  -- converting postcodes into area names, using starting letters of postcode to extract postcode area, and then join to table with UK postcode areas and area names
  -- future improvement: could have extracted more info from the london postcodes to get district names instead of North West London etc (which would have been able to join better with happiness and health datasets)

WITH pets AS(
  SELECT
    *,
    REGEXP_EXTRACT(PostcodeDistrict, r'^[A-Z]+') AS PostcodeAreaCode
  FROM
    `UK_health_and_happiness.cats_and_dogs_joined` 
  )

SELECT
  postcode.Area_Name,
  AVG(pets.DogsPerHousehold) AS average_dogs_per_household,
  AVG(pets.CatsPerHousehold) AS average_cats_per_household
FROM
  pets
LEFT JOIN
  `raw_data.UK_Postcodes` AS postcode
ON
  pets.PostcodeAreaCode = postcode.Postcode_Area
GROUP BY
  postcode.Area_Name;

  -- updating names to group London areas and some other name changes (to help with joining to health and happiness datasets)

SELECT
  CASE
    WHEN Area_Name IN(
       'Croydon', 
       'East London', 
       'Central London (East)', 
       'North London', 
       'South East London', 
       'South West London', 
       'Central London (West)', 
       'Kingston upon Thames', 
       'Sutton', 
       'Uxbridge', 
       'Romford', 
       'Twickenham', 
       'Harrow', 
       'North West London', 
       'Enfield', 
       'West London', 
       'Bromley' 
      ) THEN 'London'
    WHEN Area_Name = 'Bath' THEN 'Bath and North East Somerset'
    WHEN Area_Name = 'Brighton' THEN 'Brighton and Hove'
    WHEN Area_Name = 'Telford' THEN 'Telford and Wrekin'
    ELSE Area_Name
  END AS Updated_Area_Name,
  AVG(average_dogs_per_household) AS average_dogs_per_household,
  AVG(average_cats_per_household) AS average_cats_per_household
FROM
  `uk-health-happiness.UK_health_and_happiness.cats_dogs_by_area`
GROUP BY
  Updated_Area_Name
ORDER BY
  Updated_Area_Name;

  -- cats and dogs can now be joined to happiness and health datasets - these had been decided to keep separate and not join since happiness contained UK wide locations whereas health only contained locations in England

  -- 2) happiness and health datasets needed to be cleaned and latitude and longitude values inputted to get coordinates suitable for plotting on a Google maps chart (in Looker Studio)

  -- adding latitude and longitude columns to happiness table and concatenating and rounding latitude and longitude columns to make a coordinates column

SELECT
  ROUND(Latitude, 2) AS Latitude,
  ROUND(Longitude, 2) AS Longitude,
  CONCAT(ROUND(Latitude,2), ", ", ROUND(Longitude,2)) AS coordinates,
  area_codes,
  area_names,
  low,
  medium,
  high,
  very_high,
  average_mean_rating
FROM
  `uk-health-happiness.UK_health_and_happiness.happiness_UK` h
LEFT JOIN
  `uk-health-happiness.UK_health_and_happiness.Locations_for_happiness` l
ON
  h.area_codes=l.area_code;

  -- inserting a London row into happiness table (data from raw dataset)

INSERT INTO
  `uk-health-happiness.cleaned_data.Happiness_updated_names_29` 
  (latitude,
    longitude,
    coordinates,
    area_codes,
    area_names,
    Updated_Area_Name,
    low,
    medium,
    high,
    very_high,
    average_mean_rating)
VALUES
  (51.51, -0.12, "51.51, -0.12", "E12000007", "London", "London", 9.34,18.57,42.08, 30.01, 7.31);

  -- updating some names in area name column (need to work out which table this was on)
  
SELECT
  latitude,
  longitude,
  coordinates,
  area_codes,
  area_names,
  TRIM(CASE
      WHEN area_names = ' Aberdeen City' THEN 'Aberdeen'
      WHEN area_names = ' Blackburn with Darwen' THEN 'Blackburn'
      WHEN area_names = ' City of Edinburgh' THEN 'Edinburgh'
      WHEN area_names = ' Glasgow City' THEN 'Glasgow'
      WHEN area_names = ' Kingston upon Hull, City of' THEN 'Kingston upon Hull'
      WHEN area_names = ' Herefordshire, County of' THEN 'Herefordshire'
      WHEN area_names = ' Bristol, City of' THEN 'Bristol'
      ELSE area_names  -- Keep other values unchanged
  END
    ) AS Updated_Area_Name,
  low,
  medium,
  high,
  very_high,
  average_mean_rating
FROM
  `uk-health-happiness.cleaned_data.Happiness_updated_names_29`
ORDER BY
  Updated_Area_Name;

  -- 3) now happiness and health tables ready to be joined with cats and dogs

  -- cats and dogs to happiness table

  -- 417 rows in happiness table (includes London districts)

SELECT
  *
FROM
  `uk-health-happiness.cleaned_data.Happiness_updated_final_29`;

  -- 104 rows in pets table

SELECT
  *
FROM
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names`;

  -- joining pets to happiness - 72 rows where pets not null

SELECT
  *
FROM
  `uk-health-happiness.cleaned_data.Happiness_updated_final_29` AS happiness
LEFT JOIN
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names` AS pets
ON
  pets.Updated_Area_Name = happiness.Updated_Area_Name
WHERE
  average_dogs_per_household IS NOT NULL
ORDER BY
  happiness.Updated_Area_Name;

  -- making table, joining pets to happiness - 72 rows where pets not null

SELECT
  happiness.*,
  pets.average_dogs_per_household,
  pets.average_cats_per_household
FROM
  `uk-health-happiness.cleaned_data.Happiness_updated_final_29` AS happiness
LEFT JOIN
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names` AS pets
ON
  pets.Updated_Area_Name = happiness.Updated_Area_Name
WHERE
  average_dogs_per_household IS NOT NULL
ORDER BY
  happiness.Updated_Area_Name;

  -- cats and dogs to health table

  -- 11700 rows in health table (includes London districts)

SELECT
  *
FROM
  `uk-health-happiness.cleaned_data.Health_updated_names`;

  -- 104 rows in pets table

SELECT
  *
FROM
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names`;

  -- joining pets to health - 3432 rows where pets not null

SELECT
  *
FROM
  `uk-health-happiness.cleaned_data.Health_updated_names` AS health
LEFT JOIN
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names` AS pets
ON
  pets.Updated_Area_Name = health.Updated_Area_Name
WHERE
  average_dogs_per_household IS NOT NULL
ORDER BY
  health.Updated_Area_Name;

  -- 150 unique names in health (only England data)

SELECT
  DISTINCT(Updated_Area_Name)
FROM
  `uk-health-happiness.cleaned_data.Health_updated_names`
ORDER BY
  Updated_Area_Name;

  -- 104 unique names in pets (UK wide)

SELECT
  DISTINCT(Updated_Area_Name)
FROM
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names`
ORDER BY
  Updated_Area_Name;

  -- making table, joining to health - 3432 rows where pets not null

SELECT
  health.*,
  pets.average_dogs_per_household,
  pets.average_cats_per_household
FROM
  `uk-health-happiness.cleaned_data.Health_updated_names` AS health
LEFT JOIN
  `uk-health-happiness.cleaned_data.cats_dogs_updated_names` AS pets
ON
  pets.Updated_Area_Name = health.Updated_Area_Name
WHERE
  average_dogs_per_household IS NOT NULL
ORDER BY
  health.Updated_Area_Name;

  -- 44 unique names in pets joined to health

SELECT
  DISTINCT(Updated_Area_Name)
FROM
  `uk-health-happiness.cleaned_data.cats_dogs_health`
ORDER BY
  Updated_Area_Name;

  -- 4) health and happiness tables made with cats and dogs, weather, pollution and green spaces data

  -- weather data obtained using an API, inputing all locations found in health and happiness tables, giving daily weather data for 2015, this was averaged to get avg daily weather data for 2015 in different UK locations

  -- for happiness, joining all other factors (parks, pollution and pets) to weather and happiness (weather had greatest number of matches with the happiness data, 413 rows)

SELECT
  weather.*EXCEPT(year),
  parks.country_name,
  parks.region_name,
  parks.county_name,
  parks.LAD_name,
  parks.avg_dist_to_park,
  parks.median_dist_to_park,
  parks.avg_size_park,
  parks.median_size_park,
  parks.avg_nb_parks_within_1000m,
  parks.median_nb_parks_within_1000m,
  parks.population,
  parks.avg_pop_per_park,
  parks.median_pop_per_park,
  parks.nb_flats,
  parks.nb_flats_with_gardens,
  parks.avg_garden_size_flats,
  parks.nb_houses,
  parks.nb_houses_with_gardens,
  parks.avg_garden_size_houses,
  pollution.AirQuality,
  pollution.WaterPollution,
  pets.average_dogs_per_household,
  pets.average_cats_per_household
FROM
  `uk-health-happiness.cleaned_data.Join_weather_happiness_avg` AS weather
LEFT JOIN
  `uk-health-happiness.cleaned_data.green_spaces_all` AS parks
ON
  weather.area_codes = parks.Updated_Area_Code
LEFT JOIN
  `uk-health-happiness.cleaned_data.Happiness_air_pollution_new_30` AS pollution
ON
  weather.Region = pollution.Updated_Area_Name
LEFT JOIN
  `uk-health-happiness.cleaned_data.cats_dogs_happiness` AS pets
ON
  weather.Region = pets.Updated_Area_Name;

  -- for health, joining all other factors (parks, pollution and pets) to weather and health (weather had greatest number of matches with the health data, 11622 rows)

SELECT
  weather.*EXCEPT(year),
  parks.country_name,
  parks.region_name,
  parks.county_name,
  parks.LAD_name,
  parks.avg_dist_to_park,
  parks.median_dist_to_park,
  parks.avg_size_park,
  parks.median_size_park,
  parks.avg_nb_parks_within_1000m,
  parks.median_nb_parks_within_1000m,
  parks.population,
  parks.avg_pop_per_park,
  parks.median_pop_per_park,
  parks.nb_flats,
  parks.nb_flats_with_gardens,
  parks.avg_garden_size_flats,
  parks.nb_houses,
  parks.nb_houses_with_gardens,
  parks.avg_garden_size_houses,
  pollution.AirQuality,
  pollution.WaterPollution,
  pets.average_dogs_per_household,
  pets.average_cats_per_household
FROM
  `uk-health-happiness.cleaned_data.Join_weather_health_avg` AS weather
LEFT JOIN
  `uk-health-happiness.cleaned_data.green_spaces_all_health` AS parks
ON
  weather.Region = parks.Updated_Area_Name
  AND weather.Indicator_grouping_name = parks.Indicator_grouping_name
LEFT JOIN
  `uk-health-happiness.cleaned_data.air_pollution_health_new_30` AS pollution
ON
  weather.Region = pollution.Updated_Area_Name
  AND weather.Indicator_grouping_name = pollution.Indicator_grouping_name
LEFT JOIN
  `uk-health-happiness.cleaned_data.cats_dogs_health` AS pets
ON
  weather.Region = pets.Updated_Area_Name
  AND weather.Indicator_grouping_name = pets.Indicator_grouping_name;
