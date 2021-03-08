------------------------------------------------------------------------------
--      W O R K S H O P # 0 3 - M Y S Q L / M A R I A D B , J O I N S       --
------------------------------------------------------------------------------
-- WRITE QUERIES AND (FOR SOME QUESTIONS) COMMENTS BELOW. TRY TO DO THE     --
-- FIRST ~10 QUESTIONS. THE LATER QUESTIONS ARE MEANT TO BE MORE            --
-- CHALLENGING AND SOME MAY NOT EVEN HAVE STRAIGHTFORWARD ANSWERS.          --
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- 1.  What is the relationship between the tables: product_description and
--     product? Is it many-to-many, many-to-one or one-to-one? Hint: DESCRIBE
--     and SHOW CREATE TABLE may be helpful!
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERIES YOU USED
--     TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- The relationship between product and product_description is one to many, where product is the many side (with the foreign key) and product_description is the one side.

describe product_description;
describe product;
show create table product;
show create table product_description;

------------------------------------------------------------------------------
-- 2.  What is the relationship between the tables: report and symptom?
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERIES YOU USED
--     TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
--  The relationship between report and symptom is many to many since there is a third table called 'report_symptom' with the primary key of report and the primary key of symptom as references to be the foreign keys in the 'report_symptom' table.

describe report;
describe symptom;
describe report_symptom;
show create table report;
show create table symptom;
show create table report_symptom;

------------------------------------------------------------------------------
-- 3.  What is the relationship between the tables: report and product?
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERIES YOU USED
--     TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
--  The relationship between report and product is many to many since there is a third table called 'report_product' with the primary key of report and the primary key of product as references to be the foreign keys in the 'report_product' table.

describe report;
describe product;
describe report_product;
show create table report;
show create table product;
show create table report_product;

------------------------------------------------------------------------------
-- 4.  How many reports are in the database? Do this with a single query that
--     results in exactly one value.
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERY BELOW.
------------------------------------------------------------------------------
-- 46198
select count(*) from report;

------------------------------------------------------------------------------
-- 5.  What do the first 30 rows (include all columns) of reports look like
--     when sorted by increasing report_id?
--     WRITE THE QUERY BELOW.
------------------------------------------------------------------------------
select * from report ORDER BY report_id limit 30;

------------------------------------------------------------------------------
-- 6.  How many total products are in the database? Do this with a single
--     query that results in exactly one value. Then... with a second query,
--     show the first 30 rows, including all columns of products, this time
--     ordering by product_id.
--     WRITE YOUR ANSWER FOR THE INITIAL QUESTION IN AN SQL COMMENT FOLLOWED
--     BY BOTH QUERIES BELOW.
------------------------------------------------------------------------------
-- 28586
select count(*) from product;
select * from product ORDER BY product_id limit 30;

------------------------------------------------------------------------------
-- 7.  What is the relationship between the tables: product_description and
--     product? What are the fields contained in both tables? Which field is
--     responsible for creating the relationship between product_description
--     and product.
--     WRITE YOUR ANSWER FOR ALL QUESTIONS IN AN SQL COMMENT FOLLOWED BY THE
--     QUERIES YOU USED TO ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- The relationship between product and product_description is one to many, where product is the many side (with the foreign key) and product_description is the one side.
describe product_description;
describe product;
-- The fields contained in
  -- product: product_id, name, product_code
  -- product_description: product_code, description
-- The field responsible for creating the relationship between product_description and product is product_code.

------------------------------------------------------------------------------
-- 8.  Are there any products without a product_code?
--     WRITE YOUR ANSWER IN AN SQL COMMENT FOLLOWED BY THE QUERY YOU USED TO
--     ARRIVE AT YOUR ANSWER.
------------------------------------------------------------------------------
-- There are 2407 products without a product code.
select count(*) from product where product_code IS NULL;

------------------------------------------------------------------------------
-- 9.  Display 30 rows of products again, sorted by the name of the product in
--     alphabetical order. This time, however, show BOTH the NAME of the
--     product and its DESCRIPTION. Products without an associated description
--     should not be included. Do this without a WHERE clause.
--     WRITE YOUR QUERY BELOW.
------------------------------------------------------------------------------
select p.name, pd.description from product p right join product_description pd on p.product_code = pd.product_code ORDER BY p.name limit 30;

------------------------------------------------------------------------------
-- 10  This part has several questions to answer:
--
--     a. What should the possible values of product_type be based on the
--        documentation (https://www.fda.gov/media/97035/download)?
--     b. Which table is this field located in?
--     c. Why do you think it's included in that table?
--     d. What are the actual unique values in the database (please include the
--        correct casing) for product_type? Write a query to determine this.
--     e. Finally, find the location of the patient_age field and list out the
--        unique possible values for it as well
--
--     ANSWER QUESTIONS a - e IN SQL COMMENTS BELOW. WRITE YOUR QUERIES FOR
--     FOR QUESTIONS d and e BELOW.
------------------------------------------------------------------------------
-- a. Based on the documentation, the possible values for product_type should be either 'suspect' or 'concomitant'.

-- b. This field is located in report_product table.

-- c. This table is the table used for the many to many relationship between the report and the product table. Since suspect is the product that may have caused the adverse reaction and concomitant is a product that is in the patient's system at the time of the event, the product_type is present in the table to show which type of product is the product and report linked for.

-- d. The actual unique values are:
  -- SUSPECT
  -- CONCOMITANT
select distinct product_type from report_product;

-- e. This field is located in the report table.
describe report;
select distinct patient_age from report;

------------------------------------------------------------------------------
-- 10. How afraid should you be of yogurt? 🙀 Show the report_id, product
--     name and age of all reports that involved yogurt AS THE SUSPECT!
--
--     * again, find the rows where yogurt is suspected as the culprit for
--       the adverse reaction
--     * only include reports that have a patient's age in years
--     * sort the results by the patient's year age from oldest to youngest
--     * it's ok to hardcode strings that help your query filter:
--       * for a product name that's similar to yogurt
--       * an age that's in years
--     * but don't hardcode any other values
--     * hint: there's probably a lot of joins involved in this one!
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
select rp.report_id, p.name, r.patient_age from report_product rp inner join product p on p.product_id = rp.product_id inner join report r on r.report_id = rp.report_id where rp.product_type = 'SUSPECT' AND p.name LIKE '%yogurt%' AND r.age_units = 'year(s)' ORDER BY r.patient_age DESC;

------------------------------------------------------------------------------
-- 10. Are there any reports that include more than one product as a
--     SUSPECT? 🕵️ A yes or no answer is adequate, but write a single query
--     support your answer. Hint: can you show both the report id and the
--     number of products that are suspect that it's associated with? Taken a
--     step further, only show the reports that have more than 1 suspect
--     product.
--
--     WRITE YOUR ANSWER AND QUERY BELOW
------------------------------------------------------------------------------
-- There 14905 such reports
select report_id, count(product_id), product_type from report_product where product_type = 'SUSPECT' GROUP BY report_id HAVING count(product_id)>1;

------------------------------------------------------------------------------
-- 11. Let's try using subqueries! Use your query above as a foundation. Find
--     the average (AVG) number of products per report that has more than one
--     suspect product. 😑
--
--     * put your previous query in parentheses so that it can be used as an
--       "inner" query
--     * add a name after the parentheses to alias it (for example, tmp) so
--       so that you can refer to it in your outer query
--     * in your inner query, if you did not do so in your previous answer,
--       make sure all items in the select list are easily accessible (that
--       is, give expressions in your select list an alias with as)
--     * prior to your subquery,  you can use a select statement, but with
--       your subquery following from
--
--     WRITE YOUR ANSWER AND QUERY OR QUERIES BELOW
------------------------------------------------------------------------------
-- 2.2703 is the average number of products per report that has more than one suspect product.
select avg(total_products) from (select report_id as report_id, count(product_id) as total_products, product_type from report_product where product_type = 'SUSPECT' GROUP BY report_id HAVING count(product_id)>1) as tmp;

------------------------------------------------------------------------------
-- 12. Find the name, product code, and symptom (term) of all of the products
--     (no duplicates) that give you nightmares 😱
--
--     * again, it's ok to hardcode the part of your query that searches for
--       nightmares, but do not hardcode anything else, though
--     * only show the first 30 results
--     * sort by name, ascending
--     * hint: there's even more joins!
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
 select p.name, p.product_code, s.term from product p inner join report_product rp on p.product_id = rp.product_id inner join report_symptom rs on rp.report_id = rs.report_id inner join symptom s on rs.symptom_id = s.symptom_id where s.term LIKE '%nightmare%' ORDER BY p.name limit 30;

------------------------------------------------------------------------------
-- 13. When were the most recently entered reports (use the date that the
--     report was made rather than when the "event" happened)? 📅
--
--     This is actually two queries:
--
--     1. find the date of the most recently entered report(s)
--     2. reuse that query as part of a subquery to display the report id,
--        product name, and the date of the most recently entered event(s)
--        * do not hardcode a limit
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
-- 2019-03-30
select max(created_date) from report;

select r.report_id, p.name, r.created_date from report r inner join report_product rp on r.report_id = rp.report_id inner join product p on p.product_id = rp.product_id  where r.created_date = (select max(created_date) from report);

------------------------------------------------------------------------------
-- 14. What are the 3 most common symptoms 🤮
--
--     * include the name of the symptom and the count
--     * sorted by the count from greatest to least
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
select s.term, count(rs.symptom_id) as symtpom_count from symptom s inner join report_symptom rs on s.symptom_id = rs.symptom_id GROUP BY s.term ORDER BY symtpom_count DESC limit 3;

------------------------------------------------------------------------------
-- 15. Find the event that had the most symptoms (there could be a tie) 🤒
--
--     * show the primary key for the report, the created date, event date,
--       product, description, patient_age, sex, and all symptom terms, along
--       with the count of symptoms
--     * do this for all non exempt products (EXEMPT 4)
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
select r.report_id, r.created_date, r.event_date, p.name, r.patient_age, r.sex, s.term, count(s.term) as symptom_count from report r inner join report_symptom rs on rs.report_id = r.report_id inner join symptom s on s. symptom_id = rs.symptom_id inner join report_product rp on rp.report_id = r.report_id inner join product p on p.product_id = rp.product_id inner join product_description pd on pd. product_code = p.product_code where p.name NOT LIKE "%exempt%"  GROUP BY r.report_id ORDER BY count(s.term) DESC limit 1;

------------------------------------------------------------------------------
-- 16. Show a comma separated list of symptoms / terms for every report 📝
--
--     * the symptoms should look something like: DIZZINESS,RASH,FEVER
--     * use the aggregate function, group_concat, to do this:
--       https://mariadb.com/kb/en/group_concat/
--     * include the report_id and list out the results sorted by the
--       report_id
--     * only show 5 results
--
--     WRITE YOUR QUERY BELOW
------------------------------------------------------------------------------
select group_concat(s.term), r.report_id from report r inner join report_symptom rs on rs.report_id = r.report_id inner join symptom s on s.symptom_id = rs.symptom_id GROUP BY r.report_id ORDER BY report_id limit 5;
