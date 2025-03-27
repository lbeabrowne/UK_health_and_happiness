<div id="header" align="center">
  <h1> UK Health & Happiness 🫀😁 🏙️ </h1>
</div>

### Project Overview:
This was a 2-week capstone project at the end of Le Wagon’s Data Analytics bootcamp course. The purpose of this project was to explore which factors may be contributing to areas of high and low average health and happiness levels, which differ across the UK. This was a group project, where I worked collaboratively in a team of 4. I pitched the project idea and led the team through the 2-week sprint, successfully delivering the final project outcome in a Looker Studio dashboard which we presented as a team to the rest of the cohort.

### Tech Stack:
SQL | Python | Stats & ML | Google BigQuery | Google Colab | Looker Studio | Notion | Trello

### Factors Analysed:
- 🏭  Air quality & water pollution
- 🌱  Green spaces: parks, gardens
- 👥  Population
- 🌦️  Weather: temperature, rain, wind speed
- 🐈  Number and cats and dogs owned

### Datasets:
Most datasets were sourced from the Office of National Statistics (ONS), with the exception of the air quality & water pollution dataset which was sourced from Kaggle and an API was used for historical weather data.
<div id="badges" align="left">
    <a href="https://www.ons.gov.uk/economy/environmentalaccounts/datasets/accesstopublicgreenspaceingreatbritain">
      <img src="https://img.shields.io/badge/Greens spaces and population-29BD91?style=plastic"
        alt="Greens spaces and population button"/></a>
    <br>
    <a href="https://www.data.gov.uk/dataset/42d66627-87fe-4208-9da1-c8dc173c23ef/cats-per-household-per-postcode-district">
      <img src="https://img.shields.io/badge/Number of cats-29BD91?style=plastic"
        alt="Number of cats button"/></a>
    <br>
    <a href="https://www.data.gov.uk/dataset/7149d38e-8f06-4aac-962b-cb5c6b24915b/dogs-per-household-per-postcode-district">
      <img src="https://img.shields.io/badge/Number of dogs-29BD91?style=plastic"
        alt="Number of dogs button"/></a>
    <br>
    <a href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/healthandwellbeing/datasets/healthindexengland">
      <img src="https://img.shields.io/badge/Health-29BD91?style=plastic"
        alt="Health data button"/></a>
    <br>
    <a href="https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/datasets/measuringnationalwellbeinghappiness">
      <img src="https://img.shields.io/badge/Happiness-29BD91?style=plastic"
        alt="Happiness data button"/></a>
    <br>
    <a href="https://www.kaggle.com/datasets/patricklford/water-and-air-quality?resource=download&select=Cities1.csv">
      <img src="https://img.shields.io/badge/Air quality & water pollution-29BD91?style=plastic"
        alt="Air quality & water pollution button"/></a>
</div>

### Project Approach:
1. Data cleaning - Google BigQuery (SQL) while simultaneously exploring on Looker Studio
2. Joining datasets, paying attention to how location is defined and dates
3. Statistical analysis of factors - Google Colab (Python)
4. Exploration of machine learning models (including PyCaret library)
5. Interactive dashboard on Looker Studio
6. Presentation of project insights using dashboard and data-driven storytelling

### Insights:
#### Overall Health and Happiness Levels Around the UK:
- Health index levels in England appear to have a North South divide, with higher health levels found in areas in the South
- Average happiness levels more evenly distributed across UK, however similar areas with below average health levels also noted for below average happiness

#### Correlation of Factors Analysed with Health and Happiness:
- Positive correlation of factors with happiness (strongly to weakly positive): garden size, distance to park, nb of cats and dogs, air quality
- Negative correlation of factors with happiness (weakly negative): nb of parks within 1 km, population, water pollution
- Positive correlation of factors with health (strongly to weakly positive): max temp, nb of cats and dogs, garden size, avg temp, park size, longitude
- Negative correlation of factors with health (strongly to weakly negative): wind direction, latitude, wind speed

#### Main Findings:
- It is important to note that more detailed analysis including factors such as social and economic factors is needed to determine causation of the different health and happiness levels around the UK
- From this project's analysis, correlation, and not causation, could only be determined
- Despite this, some interesting trends were extracted from our analysis:
  <br>
👥 Areas with high population density have on average lower happiness levels
  <br>
🌱 Being close to a park does not correlate with higher happiness (distance to park negatively correlates with population therefore this might be the contributing factor)
  <br>
🌱 Average garden size had strongest correlation with both happiness and health (likely to be strongly linked to wealth and income levels)
  <br>
🏭 Areas with higher pollution levels have lower than average happiness and health levels
  <br>
🌦️ From weather analysis, areas with higher wind speeds (e.g. coastal cities) tend to have a lower health index and areas with higher temperatures tend to have a higher health index - question as to whether there is a link to increased outdoor physical activity due to weather factors
  <br>
🐈 Higher numbers of cats and dogs owned per area correlate with higher health and happiness levels (likely to be linked with economic and demographic factors)

### Dashboard:
Click the button below if you want to see the dashboard!
<div id="badges" align="left">
    <a href="https://invited-pest-6fb.notion.site/UK-Health-Happiness-Project-19a97beee4ab80fd9fe4dc58a0a83ef9">
      <img src="https://img.shields.io/badge/Portfolio-ef3b2c?logo=Notion&logoColor=white&style=plastic"
        alt="Portfolio Button"/></a>
</div>

