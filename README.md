# Real-estate-data-analysis
Project is an Exploratory Data Analysis of a property dataset aiming to uncover patterns within the real estate market in these cities.
Data was in csv file format opened it in MS Excel did some little cleaning saved it in xlsx format so as to make it more convenient to import it into Microsoft SQL Server as a database.

![ope](https://user-images.githubusercontent.com/107225504/226689468-203bb903-ac2a-4087-a023-0bf0cfcf93e8.jpg)

## Data cleaning
Upon getting data into SQL Server initially selected all the data to take a look at what we are working with. then began to perform some data cleaning operations like updated null rows in property address using self-join ,seperating address data and some other changes to the data which can all be seen in the SQL script attached to this documentation to make it more suitable for analysis .

## Exploratory Data Analysis
Taking a look at all the columns to have an idea on how to proceed first looked at total value of properties .

Looked at no of homes bought as empty ina view Home_Status
![Uploading image.png…]()

 Querying for spread of properties across cities Nashville with 71.33911624% of all properties across 13 cities
Also made grouping of timeof construction of buildings

Queried data thoroughly to gain full understandimg of it such as price in relation to various metrics such as property type,whether the properties were overpaid for ,owners with most properties owned.
Wrote query to look at valuations of properties comparing price sold for to the property value to determine if property was a bargain or perhaps if it was overpriced.
  ![image](https://user-images.githubusercontent.com/107225504/226688417-bed9f677-71d2-43f3-a00a-b9c562e0b179.png)

Querying was extensive and I was able to gain deep understanding of the dataset.
## Data Visualization
After concluding with the query I then connected SQL Server to PowerBI in order to visualise insights gained from the query as visualization is proven method of sharing insights.
Report created in PowerBI is seen below

![image](https://user-images.githubusercontent.com/107225504/226690120-c211345b-eb7c-4020-a45d-3f36457cf692.png)


## Conclusion
Project was able to show workflow of getting a csv File looking through in excel, creating database in sql server and querying said data and finally connecting to PowerBI in order to better share insights gained .
Real estate data was well understood and enabled me to create visual to highlight important insghts from within to stakeholders.


