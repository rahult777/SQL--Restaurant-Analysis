
# Restaurant Dataset :

select * from userprofile;
select * from chefmozaccepts;
select * from chefmozcuisine;
select * from  chefmozhours4;
select * from chefmozparking;
select * from  geoplaces2;
select * from usercuisine;
select * from rating_final;
select * from userpayment;
select * from userprofile;


#Q1: - We need to find out the total visits to all restaurants under all alcohol categories available.
select * from geoplaces2;
SELECT Alcohol, COUNT(*) AS TotalVisits
FROM geoplaces2
GROUP BY Alcohol;


#Q2: -Let's find out the average rating according to alcohol and
#price so that we can understand the rating in respective price categories as well.

SELECT Alcohol, Price, AVG(Rating) AS AvgRating
FROM geoplaces2 g join rating_final r 
on r.placeID=g.placeID
GROUP BY Alcohol, Price;

#Q3:  Let’s write a query to quantify that what are the parking availability as
#well in different alcohol categories along with the total number of restaurants.
select * from geoplaces2;
SELECT Alcohol, SUM(CASE WHEN Parking_lot IS NOT NULL THEN 1 ELSE 0 END) AS RestaurantsWithParking,
count(*) AS TotalRestaurants
FROM geoplaces2 g join 
chefmozparking c on c.placeID=g.placeID
GROUP BY Alcohol;

#Q4: Also take out the percentage of different cuisine in each alcohol type.
#Let us now look at a different prospect of the data to check state-wise rating.

SELECT Alcohol, Rcuisine, COUNT(*) AS CuisineCount,
(COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY Alcohol)) AS Percentage
FROM Chefmozcuisine c
JOIN geoplaces2 g ON c.PlaceID = g.PlaceID
GROUP BY Alcohol, Rcuisine;

#Q5: let’s take out the average rating of each state.


SELECT State, AVG(Rating) AS AvgRating
FROM geoplaces2 g
join rating_final r 
on r.placeID=g.placeID
GROUP BY State;

#Q6: -' Tamaulipas' Is the lowest average rated state. Quantify the reason why it is the lowest
#rated by providing the summary on the basis of State, alcohol, and Cuisine.

SELECT State, Alcohol, Rcuisine, AVG(Rating) AS AvgRating
FROM geoplaces2 g
join Chefmozcuisine c
ON c.PlaceID = g.PlaceID
join rating_final r 
on r.placeID=g.placeID
WHERE State = 'Tamaulipas'
GROUP BY State, Alcohol, Rcuisine;

#Q7:  - Find the average weight, food rating, and service rating of the customers
#who have visited KFC and tried Mexican or Italian types of cuisine, and also their budget level is low.
#We encourage you to give it a try by not using joins.

SELECT AVG(up.Weight) AS AvgWeight, AVG(rf.Food_Rating) AS AvgFoodRating, AVG(rf.Service_Rating) AS AvgServiceRating
FROM Userprofile up
INNER JOIN rating_final rf ON up.UserID = rf.UserID
INNER JOIN Usercuisine uc ON up.UserID = uc.UserID
WHERE uc.Rcuisine IN ('Mexican', 'Italian')
AND up.Budget = 'low' AND EXISTS 
(SELECT 1 FROM geoplaces2 gp WHERE gp.Name = 'KFC');
