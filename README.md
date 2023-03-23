# Introduction
Project aim is to uncover valuable insights within the dataset in order to enable stakeholders to take better decisions  in their dealings on the real estate market.

This is an exploratory data analysis of a property dataset aiming to uncover patterns within the real estate market in these cities.
Data was in csv file format opened it in MS Excel did some little cleaning saved it in xlsx format so as to make it more convenient to import it into Microsoft SQL Server as a database.


![ope](https://user-images.githubusercontent.com/107225504/226689468-203bb903-ac2a-4087-a023-0bf0cfcf93e8.jpg)

## Data cleaning
Upon getting data into SQL Server initially selected all the data to take a look at what we are working with. then began to perform some data cleaning operations like updating null rows in property address using self-join ,seperating address data and some other changes to the data which can all be seen in the SQL script attached to this documentation to make it more suitable for analysis .

## Exploratory Data Analysis
Taking a look at all the columns,first looked at the total value of properties

![image](https://user-images.githubusercontent.com/107225504/226691692-8aa9fe7f-8c03-4910-950b-9575490b04c6.png)

Also looked at no of homes bought empty in a view Home_Status
![image](https://user-images.githubusercontent.com/107225504/226691583-61243110-2a67-4b31-bb22-d1044db91a09.png)
 
Querying for spread of properties across cities. Nashville with 71.33911624% of all properties across 13 cities
![image](https://user-images.githubusercontent.com/107225504/226693012-8604cf5f-ef2d-4213-8856-1d9057f06fb0.png)

Also made grouping of time of construction of buildings

![image](https://user-images.githubusercontent.com/107225504/226691827-e3b2959f-b8d8-4024-824e-d845cfdd4d9c.png)


Wrote query to look at valuations of properties comparing price sold for to the property value to determine if property was a bargain or perhaps  if it was overpriced.

![image](https://user-images.githubusercontent.com/107225504/226688417-bed9f677-71d2-43f3-a00a-b9c562e0b179.png)

Queried data thoroughly to gain full understanding of it such as price in relation to various metrics such as property type,whether the properties were overpaid for ,owners with most properties owned
and I was able to gain deep understanding of the dataset.The full query is contained in the file attached. 

## Data Visualization
After concluding with the query I then connected SQL Server to PowerBI in order to visualise insights gained from the query as visualization is proven method of sharing insights.

Report created in PowerBI is seen below and is also attached if you wish to interact with the report.

![image](https://user-images.githubusercontent.com/107225504/227245743-335d60ed-a065-4566-a6b0-e699b66ac64a.png)

## Conclusion
Project was able to show workflow of getting a csv file creating database in sql server to import the csv file into and querying said data and finally connecting to PowerBI in order to better share insights gained .
I was able to perform extensive analysis on the real estate data and as a result the data was well understood and enabled me to create a visual to highlight important insights from within to stakeholders which would help them take data driven decisions on the real estate market.


