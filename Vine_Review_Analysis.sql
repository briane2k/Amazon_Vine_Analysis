--4,864,249 for whole table
--   65,871 for just total_votes>20
--   59,221 for just total_votes>20 and xx>0.5

--paid 1,203 rows of 59,221
CREATE TABLE vine_paid AS
	SELECT review_id, star_rating, helpful_votes, total_votes, vine, verified_purchase, CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) AS HVRatio
	FROM vine_table
	WHERE (total_votes > 20) AND (CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT)) >= 0.5
	AND vine = 'Y';

--unpaid 58,018 rows of 59,221
CREATE TABLE vine_unpaid AS
	SELECT review_id, star_rating, helpful_votes, total_votes, vine, verified_purchase, CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) AS HVRatio
	FROM vine_table
	WHERE (total_votes > 20) AND (CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT)) >= 0.5
	AND vine = 'N'

--Determine the total number of reviews, the number of 5-star reviews, and the percentage of 5-star reviews for the two types of review (paid vs unpaid).

--inspiration from https://id-in-it.com/count-multiple-columns-in-postgresql
--and https://stackoverflow.com/questions/52220166/postgres-sql-round-to-2-decimal-places
WITH DTBL AS (	
	--1203	410
	SELECT 'Paid Reviews' as revType,
		sum(1) as Total,
		sum(case when star_rating >=5 then 1 end) as Goodreviews
	FROM vine_paid
	UNION
	--58018	28043
	SELECT 'Un-Paid Reviews' as revType,
		sum(1) as Total,
		sum(case when star_rating >=5 then 1 end) as Goodreviews
	FROM vine_unpaid
)
SELECT revType, Total, Goodreviews, round(Goodreviews/Total::numeric, 2) as PercGoodRev
FROM DTBL


