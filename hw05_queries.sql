-----------------------------------------------------------------------------
-- 1. In an SQL comment below, describe the relationship (one-to-one,
--    many-to-one, or many-to-many) between the pairs of tables listed
--    (note that you may need to look at a third table to determine the
--    relationship).
--
--    Additionally, add the queries you used to arrive at your answers.
--
--    a. countries and country_stats
--    b. languages and countries
--    c. continents and regions
-----------------------------------------------------------------------------
-- Relationships are:
--a. countries and country_stats - Many to One relationship.
-- country_stats on the many side and countries on the one side.
-- As the foreign key is in the country_stats table
show create table countries;
show create table country_stats;
describe countries;
describe country_stats;

--b. languages and countries - Many to Many relationship.
-- since there is a third table called 'country_languages' with the primary key of countries and the primary key of languages as references to be the foreign keys in the 'country_languages' table.
Show tables;
describe countries;
describe languages;
describe country_languages;
show create table countries;
show create table languages;
show create table country_languages;

--c. continents and regions - Many to One relationship.
-- regions on the many side and continents on the one side.
-- As the foreign key is in the regions table
describe continents;
describe regions;
show create table continents;
show create table regions;

-----------------------------------------------------------------------------
-- 2. Create a report displaying every name and population of every
--    continent in the database from the year 2018 with millions as units
--
--    For example:
--
-- Asia           4376.9086
-- Africa         1259.7617
-- Europe          717.2167
-- North America   569.6298
-- South America   394.5288
-- Oceania          40.9416
--
--     Write your query below.
-----------------------------------------------------------------------------
select c.name, sum(cs.population)/1000000 as population from country_stats cs  inner join countries c on c.country_id = cs.country_id  inner join regions r on c.region_id = r.region_id inner join continents cn on cn.continent_id = r.continent_id where cs.year = 2018 GROUP BY cn.continent_id ORDER BY population DESC;


-----------------------------------------------------------------------------
-- 3. List the names of all of the countries that do not have a language.
--    Write your answer in an SQL comment below along with the original
--    query that you used to arrive at your answer.
-----------------------------------------------------------------------------
-- +----------------------------------------------+
-- | name                                         |
-- +----------------------------------------------+
-- | Antarctica                                   |
-- | French Southern territories                  |
-- | Bouvet Island                                |
-- | Heard Island and McDonald Islands            |
-- | British Indian Ocean Territory               |
-- | South Georgia and the South Sandwich Islands |
-- +----------------------------------------------+

select c.name from countries c left outer join country_languages cl on cl.country_id = c.country_id left outer join languages l on l.language_id = cl.language_id where l.language is NULL;

-- select c.name, cl.language_id, l.language from countries c left outer join country_languages cl on cl.country_id = c.country_id left outer join languages l on l.language_id = cl.language_id where l.language is NULL;

-----------------------------------------------------------------------------
-- 4. Show the country name and total number of languages of the top 10
--    countries with the most languages in descending order (according to the
--    data in this data set). Write your query below.
-----------------------------------------------------------------------------
select c.name, count(l.language) from countries c inner join country_languages cl on cl.country_id = c.country_id inner join languages l on cl.language_id = l.language_id GROUP BY c.name ORDER BY count(l.language) DESC limit 10;

-----------------------------------------------------------------------------
-- 5. Repeat your previous query, but with a comma separated list of
--    languages rather than a count. For example:
--
--     name   | languages
--     -------+---------------------------------
--     Canada |  "Dutch,English,Spanish,French,Portuguese,Italian,German,Polish,Ukrainian,Chinese,Eskimo Languages,Punjabi"
--
--    Hint: use the aggregate function, group_concat to do this
--
--    Write your code below
-----------------------------------------------------------------------------
select c.name, group_concat(l.language) from countries c inner join country_languages cl on cl.country_id = c.country_id inner join languages l on cl.language_id = l.language_id  GROUP BY c.name ORDER BY count(l.language) DESC limit 10;

-----------------------------------------------------------------------------
-- 6. What's the average number of languages in every country in a region in
--    the dataset? Show both the region's name and the average. Make sure to
--    include countries that don't have a language in your calculations.
--
--    Hint: using your previous queries and additional subqueries may
--    help
--
--    Write your query below.
-----------------------------------------------------------------------------
select r.name, avg(tl) as average from (select c.name, c.region_id, count(l.language) as tl from countries c inner join country_languages cl on c.country_id = cl.country_id inner join languages l on l.language_id = cl.language_id group by c.name) as innertable inner join regions r where r.region_id = innertable.region_id GROUP BY r.region_id ORDER BY average DESC;

-----------------------------------------------------------------------------
-- 7. Show the country name and its "national day" for the country with
--    the most recent national day and the country with the oldest national
--    day. Do this with a *single query*.
--
--    Hint: both subqueries and union may be helpful here
--
--    The output may look like this:
--
--   name      | national_day
-- ------------+--------
-- East Timor  | 2002-05-20
-- Switzerland | 1291-08-01
--
-----------------------------------------------------------------------------
select c.name, c.national_day from countries c where national_day = (select max(national_day) as nationalDay from countries) union select c.name,c.national_day from countries c where national_day = (select min(national_day) as nationalDay from countries);

-----------------------------------------------------------------------------
-- 8. In an SQL comment below, formulate your own question about this data
--    set and write a query to answer it.
-----------------------------------------------------------------------------
-- What is the maximum total gdp of a country? (per million)

-- Answer is:
-- +---------------------+
-- | max_gdp_per_million |
-- +---------------------+
-- |           425880190 |
-- +---------------------+

-- Query used for the answer is:
select round(max(total_gdp)/1000000) as max_gdp_per_million from (select c.name as name, sum(cs.gdp)as total_gdp from countries c inner join country_stats cs on c.country_id = cs.country_id group by name) tmp;
