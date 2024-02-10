USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from director_mapping;
-- 3867 rows

select count(*) from genre;
-- 14662 rows

select count(*) from movie;
-- 7997 rows

select count(*) from names;
-- 25735 rows

select count(*) from ratings;
-- 7997 rows

select count(*) from role_mapping;
-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select Sum(case
             when id is null then 1
             else 0
           end) as Null_ids,
       Sum(case
             when title is null then 1
             else 0
           end) as Null_titles,
       Sum(case
             when year is null then 1
             else 0
           end) as Null_year,
       Sum(case
             when date_published is null then 1
             else 0
           end) as Null_date_published,
       Sum(case
             when duration is null then 1
             else 0
           end) as Null_duration,
       Sum(case
             when country is null then 1
             else 0
           end) as Null_country,
       Sum(case
             when worlwide_gross_income is null then 1
             else 0
           end) as Null_gross_income,
       Sum(case
             when languages is null then 1
             else 0
           end) as Null_language,
       Sum(case
             when production_company is null then 1
             else 0
           end) as Null_production_co
FROM   movie;

-- columns with null values are Country, Worlwide_Gross_Income, Languages and Production_Company


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year, count(title) as number_of_movies
from movie
group by year;

-- movies released in the year 2017, 2018 and 2019 respectively are 3052, 2944 and 2001.

select month(date_published) as month_num, count(title) as number_of_movies
from movie
group by month_num
order by month_num;

/*Output for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+-------------------+
|	1			|	 804			|
|	2			|	 640			|
|	3			|	 824			|
|	4			|	 680			|
|	5			|	 625			|
|	6			|	 580			|
|	7			|	 493			|
|	8			|	 678			|
|	9			|	 809			|
|	10			|	 801			|
|	11			|	 625			|
|	12			|	 438			|
+---------------+-------------------+ */



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select year, country, count(id) as number_of_movies_produced
from movie
where year = 2019 and country like '%USA%' or country like '%India%';

-- Number of movies produced in the USA or India in the year 2019 is 1818.

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre
from genre;

-- The unique genres are Adventure, Action, Sci-Fi, Crime, Mystery, Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance and Others


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select count(id) as number_of_movies, genre
from movie m
inner join genre g
on m.id = g.movie_id
group by genre
order by number_of_movies desc
limit 1;

-- There were 4285 movies produced in the Drama genre.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with movies_in_one_genre
     as (select movie_id
         from genre
         group by movie_id
         having Count(distinct genre) = 1)

select Count(*) as movies_in_one_genre
from movies_in_one_genre;

-- Movies that were made in only one genre are 3289 in number.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, avg(duration) as avg_duration
from movie m
inner join genre g
on m.id = g.movie_id
group by genre;

/*  Drama		106.7746
	Fantasy		105.1404
	Thriller	101.5761
	Comedy		102.6227
	Horror		92.7243
	Family		100.9669
	Romance		109.5342
	Adventure	101.8714
	Action		112.8829
	Sci-Fi		97.9413
	Crime		107.0517
	Mystery		101.8000
	Others		100.1600 */


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with rankings as (
	select genre, count(movie_id) as movie_count, rank() over (order by Count(movie_id) desc) as genre_rank
	from genre
    group by genre)

select *
from rankings
where genre = 'Thriller';

-- Movie count for the genre Thriller is 1484 making it the 3rd ranking in all genres

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes, max(total_votes) as max_total_votes, min(median_rating) as min_median_rating, max(median_rating) as max_median_rating
from ratings;

/* Output:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|		10.0    	|	       100		  |	   725138	   		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title, avg_rating, rank() over (order by avg_rating desc) as movie_rank
from movie m
inner join ratings r
on m.id = r.movie_id
limit 10;

/* Output format:
+-----------------------------+-----------------+-----------------------+
| title			              |		avg_rating	|		movie_rank      |
+-----------------------------+-----------------+-----------------------+
| Kirket	                  |		10.0		|			1	  	    |
| Love in Kilnerry            |		10.0		|			1		    |
| Gini Helida Kathe           |		9.8 		|			3		    |
| Runam                 	  |		9.7	    	|			4		    |
| Fan                      	  |		9.6	    	|			5	  	    |
| Android Kunjappan Version	  |		9.6 		|			5	  	    |
| Yeh Suhaagraat Impossible	  |		9.5 		|			7	  	    |
| Safe		                  |		9.5 		|			7	  	    |
| The Brighton Miracle    	  |		9.5 		|			7	  	    |
| Shibu		                  |		9.4 		|			10	  	    |
+-----------------------------+-----------------+-----------------------+*/



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating, count(id) as movie_count
from movie m
inner join ratings r
on m.id = r.movie_id
group by median_rating
order by movie_count desc;

/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	7			|		2257		|
|	6			|		1975		|
|	8			|		1030		|
|	5			|		985			|
|	4			|		479			|
|	9			|		429			|
|	10			|		346			|
|	3			|		283			|
|	2			|		119			|
|	1			|		94			|
+---------------+-------------------+ */

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with hit_production_house as (
	select production_company, count(id) as movie_count, rank() over (order by count(id) desc) as prod_company_rank
	from movie m
	inner join ratings r
	on m.id = r.movie_id
	where avg_rating > 8 and production_company is not null
    group by production_company
)

select *
from hit_production_house
where prod_company_rank = 1;

/* Output:
+------------------------+-----------------+---------------------+
|production_company      |   movie_count   |  prod_company_rank  |
+------------------------+-----------------+---------------------+
| Dream Warrior Pictures |		3		   |			1	  	 |
| National Theatre Live  |		3		   |			1	  	 |
+------------------------+-----------------+---------------------+*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, count(id) as movie_count
from movie m
inner join ratings r
on m.id = r.movie_id
inner join genre g
on g.movie_id = m.id
where year = 2017 and month(date_published) = 3 and country like '%USA%' and total_votes > 1000
group by genre
order by movie_count desc;

/* Output:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	Drama   	|		24			|
|	Comedy		|		9			|
|	Action	    |		8			|
|	Thriller   	|		8			|
|	Sci-Fi	    |		7			|
|	Crime  	    |		6			|
|	Horror   	|		6			|
|	Mystery  	|		4			|
|	Romance  	|		4			|
|	Fantasy   	|		3			|
|	Adventure   |		3			|
|	Family	    |		1			|
+---------------+-------------------+ */


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select title, avg_rating, genre
from movie m
inner join ratings r
on m.id = r.movie_id
inner join genre g
on g.movie_id = m.id
where title like 'The%' and avg_rating > 8
group by title
order by avg_rating desc;

/* Output format:
+---------------------------------------+-------------------+-------------+
|               title		           	|	 avg_rating	    |	 genre    |
+---------------------------------------+-------------------+-------------+
| The Brighton Miracle	            	|		9.5			|	 Drama	  |
| The Colour of Darkness.	      		|		9.1			|	 Drama	  |
| The Blue Elephant	2	             	|		8.8			|	 Drama	  |
| The Irishman		                 	|		8.7			|	 Crime	  |
| The Mystery of Godliness: The Sequel	|		8.5			|	 Drama	  |
| The Gambinos			                |		8.4			|	 Crime	  |
| Theeran Adhigaaram Ondru	    		|		8.3 		|	 Action	  |
| The King and I		            	|		8.2			|	 Drama	  |
+---------------------------------------+-------------------+-------------+*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(id) as no_of_movies, median_rating
from movie m
inner join ratings r
on m.id = r.movie_id
where date_published BETWEEN '2018-04-01' AND '2019-04-01' and median_rating = 8
group by median_rating;

-- 361 movies were given a median rating of 8 between the period of 1 April 2018 and 1 April 2019.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select languages, sum(total_votes) as votes
from movie m
inner join ratings r
on m.id = r.movie_id
where languages like '%German%'
union
select languages, sum(total_votes) as votes
from movie m
inner join ratings r
on m.id = r.movie_id
where languages like '%Italian%'
order by votes desc;

-- votes for German language (4421525) are more than the votes received for Italian language movies (2559540).

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select Sum(case
             when name is null then 1
             else 0
           end) as name_nulls,
       Sum(case
             when height is null then 1
             else 0
           end) as height_nulls,
       Sum(case
             when date_of_birth is null then 1
             else 0
           end) as date_of_birth_nulls,
       Sum(case
             when known_for_movies is null then 1
             else 0
           end) as known_for_movies_nulls
From names;

-- Columns height, date_of_birth and known_for_movies have 17335, 13431 and 15226 null values respectively.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_genres as (
	select genre, count(id) as movie_count, rank() over (order by count(id) desc) as genre_rank
	from movie m
	inner join genre g
	on m.id = g.movie_id
	inner join ratings r
	on m.id = r.movie_id
	where avg_rating > 8
	group by genre
	limit 3)
    
select name as director_name, count(id) as movie_count
from director_mapping d
inner join genre g
on d.movie_id = g. movie_id
inner join names n
on d.name_id = n.id
inner join top_genres t
on g.genre = t.genre
inner join ratings r
on d. movie_id = r.movie_id
where avg_rating > 8
group by director_name
order by movie_count desc
limit 3;

/* Output:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|Anthony Russo	|		3			|
|Soubin Shahir	|		3			|
+---------------+-------------------+ */

--  the top three directors in the top three genres whose movies have an average rating > 8 are James Mangold, Anthony Russo, Soubin Shahir

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select name as actor_name, count(movie_id) as movie_count
from role_mapping r_m
inner join movie m
on m.id = r_m.movie_id
inner join ratings r
using (movie_id)
inner join names as n
on n.id = r_m.name_id
where  r.median_rating >= 8 and category = 'actor'
group by actor_name
order by movie_count desc
limit  2;

/* Output:
+---------------+-------------------+
| actor_name	|	movie_count		|
+---------------+-------------------+
|Mammootty  	|		8			|
|Mohanlal		|		5			|
+---------------+-------------------+ */


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, sum(total_votes) as vote_count, rank() over (order by sum(total_votes) desc) as prod_comp_rank
from movie m
inner join ratings r
on m.id = r.movie_id
group by production_company
limit 3;

/* Output:
+-------------------------+-----------------+---------------------+
|production_company       |vote_count		|	prod_comp_rank    |
+-------------------------+-----------------+---------------------+
| Marvel Studios          |	2656967			|		1	  		  |
| Twentieth Century Fox   |	2411163			|		2   		  |
| Warner Bros.	          |	2396057			|		3   		  |
+-------------------------+-----------------+---------------------+*/

-- Marvel Studios ranks no. 1 with 2656967 total votes.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Note: calculating weighted average by --> sum(avg_rating * total_votes) / sum(total_votes)

with actor_details as (
	select name as actor_name, total_votes, count(r.movie_id) as movie_count, round(sum(avg_rating * total_votes) / sum(total_votes), 2) as actor_avg_rating
	from movie as m
	inner join ratings as r
	on m.id = r.movie_id
	inner join role_mapping as r_m
	on m.id = r_m.movie_id
	inner join names as n
	on r_m.name_id = n.id
	where country = 'India' and category = 'actor'
	group by name
	having movie_count >= 5)
    
select actor_name, total_votes, movie_count, actor_avg_rating, rank() over (order by actor_avg_rating desc) as actor_rank
from actor_details;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actress_details as (
	select n.name as actress_name, total_votes, count(r.movie_id) as movie_count, round(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating
	from movie m
	inner join ratings r
	on m.id=r.movie_id
	inner join role_mapping r_m
	on m.id = r_m.movie_id
	inner join names as n
	on r_m.name_id = n.id
	where country = 'India' and category = 'Actress' and languages like '%Hindi%'
	group by name
	having movie_count >= 3)

select *, rank() over (order by actress_avg_rating desc) as actress_rank
from actress_details
limit 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with genre_thriller as (
	select distinct title, avg_rating
	from movie m
	inner join ratings r
	on r.movie_id = m.id
	inner join genre g
	using (movie_id)
	where genre = 'THRILLER')

select *,
	case
		when avg_rating > 8 then 'Superhit movies'
		when avg_rating between 7 and 8 then 'Hit movies'
		when avg_rating between 5 and 7 then 'One-time-watch movies'
		else 'Flop movies'
	end as avg_rating_category
from genre_thriller
order by avg_rating desc; 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre, round(avg(duration),2) as avg_duration, sum(round(avg(duration), 2)) over (order by genre rows unbounded preceding) as running_total_duration, avg(round(avg(duration), 2)) over (order by genre rows 10 preceding) as moving_avg_duration
from movie m 
inner join genre g 
on m.id= g.movie_id
group by genre
order by genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_three_genres as (
		select genre, count(m.id) as movie_count, rank() over(order by count(m.id) desc) as genre_rank
		from movie m
		inner join genre g
		on g.movie_id = m.id
		inner join ratings r
		on r.movie_id = m.id
		where avg_rating > 8
		group by genre
		limit 3), movies as (
	select genre, year, title as movie_name, cast(replace(replace(ifnull(worlwide_gross_income,0),'inr',''),'$','') as decimal(10)) as worlwide_gross_income, dense_rank() over(partition by year order by cast(replace(replace(ifnull(worlwide_gross_income,0),'inr',''),'$','') as decimal(10))  desc ) as movie_rank
	from movie m
	inner join genre g
	on m.id = g.movie_id
	where genre in (select genre from   top_three_genres)
	group by movie_name)
select *
from movies
where movie_rank<=5
order by year;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with top_production_companies as (
	select production_company, count(*) as movie_count
	from movie m
	inner join ratings r
	on r.movie_id = m.id
	where production_company is not null and median_rating >= 8 and position(',' in languages) > 0
	group  by production_company
	order  by movie_count desc)
select *, rank() over (order by movie_count desc) as prod_comp_rank
from top_production_companies
limit 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

/* Output:
+-----------------------+---------------+-----------------+
|production_company     |  movie_count	|   prod_comp_rank|
+-----------------------+---------------+-----------------+
| Start Cinema		    |		7		|		1		  |
| Twentieth Century Fox	|		4		|		2		  |
+-----------------------+---------------+-----------------+*/

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actress_details as (
	select n.name as actress_name, sum(total_votes) as total_votes, count(r.movie_id) as movie_count, round(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating
	from movie m
	inner join ratings r
	on m.id=r.movie_id
	inner join role_mapping as r_m
	on m.id = r_m.movie_id
	inner join names as n
	on r_m.name_id = n.id
	inner join genre as g
	on g.movie_id = m.id
	where category = 'Actress' and avg_rating>8 and genre = 'Drama'
	group by name)
    
select *, rank() over(order by movie_count desc) as actress_rank
from actress_details
limit 3;

/* Output:
+-----------------------+-------------------+---------------------+----------------------+-----------------+
|    actress_name	    |	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+-----------------------+-------------------+---------------------+----------------------+-----------------+
|	Parvathy Thiruvothu	|			4974	|	       2		  |	   8.25			     |		1	       |
|	Susan Brown 		|			656		|	       2		  |	   8.94	    		 |		1	       |
|	Amanda Lawrence		|			656		|	       2		  |	   8.94	    		 |		1	       |
+-----------------------+-------------------+---------------------+----------------------+-----------------+*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with movies_released as (
		select d.name_id, name, d.movie_id, duration, r.avg_rating, total_votes, m.date_published, lead(date_published,1) over(partition by d.name_id order by date_published,movie_id ) as next_date_published
		from director_mapping d
		inner join names as n
		on n.id = d.name_id
		inner join movie as m
		on m.id = d.movie_id
		inner join ratings r
		on r.movie_id = m.id ), top_directors as (
	select *, datediff(next_date_published, date_published) as date_difference
    from movies_released)
       
select name_id as director_id, name as director_name, count(movie_id) as number_of_movies, round(avg(date_difference),2) as avg_inter_movie_days, round(avg(avg_rating),2) as avg_rating, sum(total_votes) as total_votes, min(avg_rating) as min_rating, max(avg_rating) as max_rating, sum(duration) as total_duration
from top_directors
group by director_id
order by count(movie_id) desc
limit 9;