-- 1a. Display the first and last names of all actors from the table actor.
use sakila;
select first_name , last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
alter table actor add Actor_Name varchar(50);
update actor set Actor_Name = concat(first_name , ' ' , last_name);	

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name 
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name , first_name from actor 
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id , country
from country
where country in ( 'Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `First_Name`;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

-- 3c. Now delete the middle_name column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(last_name)
from actor
group by last_name
having count(last_name) > 1;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor
set first_name = replace(first_name, 'GROUCHO' , 'HARPO')
where last_name = 'WILLIAMS';

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)*/
update actor set first_name =
case 
	when first_name = 'GROUCHO' then 'MUCHO GROUCHO'
    when first_name = 'HARPO' then 'GROUCHO'
    else first_name
end;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`));

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select staff.first_name , staff.last_name, address.address
from staff	
join address on 
staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select staff.first_name , staff.last_name, address.address, sum(payment.amount)
from staff	
join address on 
staff.address_id = address.address_id
join payment on
staff.staff_id = payment.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.title , count(distinct film_actor.actor_id)
from film_actor
inner join film on
film.film_id = film_actor.film_id
group by film.title ;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(film_id)
from inventory
where film_id in (
	select film_id 
    from film 
    where title = 'Hunchback Impossible'
    );

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select sum(payment.amount) , customer.first_name , customer.last_name, customer.customer_id 
from payment
join customer on
payment.customer_id = customer.customer_id
group by customer_id ;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/

select title 
from film
where language_id = 1
and title like 'Q%' or title like 'K%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.   
select first_name, last_name 
from actor 
where actor_id in
( select actor_id 
	from film_actor
		where film_id in
        (select film_id 
			from film
				where title = 'Alone Trip')
                );
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name, email 
from customer
where address_id in
	(select address_id 
		from address
        where city_id in (
			select city_id 	
            from city 
            where country_id in
				(select country_id 
					from country 
                    where country = 'Canada' 
                    )));
		
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
select title
from film
where film_id in 
	(select film_id 
		from film_category
        where category_id in
			(select category_id 
				from category
                where category.name = 'family'));
                
-- 7e. Display the most frequently rented movies in descending order.

select count(distinct rental.inventory_id) , film.title
from rental 
join inventory on
rental.inventory_id = inventory.inventory_id
join film on
film.film_id = inventory.film_id
group by film.title
order by count(distinct rental.inventory_id) desc ;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select sum(payment.amount) , store.store_id
from store
join staff on 
store.manager_staff_id = staff.staff_id
join payment on
staff.staff_id = payment.staff_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id , city.city, country.country
from store
join address on 
store.address_id = address.address_id
join city on
address.city_id = city.city_id
join country on
city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name , sum(payment.amount) 
from category
join film_category on 
category.category_id = film_category.category_id
join film on
film_category.film_id = film.film_id
join inventory on
film.film_id = inventory.film_id
join rental on
inventory.inventory_id = rental.inventory_id
join payment on
rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5 ;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view top_five_genre_by_gross_revenue as 
select category.name , sum(payment.amount) 
from category
join film_category on 
category.category_id = film_category.category_id
join film on
film_category.film_id = film.film_id
join inventory on
film.film_id = inventory.film_id
join rental on
inventory.inventory_id = rental.inventory_id
join payment on
rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5 ;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.top_five_genre_by_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genre_by_gross_revenue;