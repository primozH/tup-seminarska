CREATE DATABASE yelp
GO

ALTER DATABASE yelp
SET RECOVERY SIMPLE
GO

USE yelp
GO

DROP TABLE IF EXISTS Bussines
GO

SELECT business_id,business_name,neighborhood,business_address,business_city,business_state,postal_code,latitude,longitude,stars,review_count,is_open,attributes,categories,business_hours,item_type
INTO Business
FROM OPENROWSET (BULK 'C:\Yelp\business.json'
	,FORMATFILE = 'C:\Yelp\xml\linebyline.xml'
	,CODEPAGE = '65001'
	) as j
 CROSS APPLY OPENJSON(SingleLine)
 WITH( 
	business_id varchar(100) '$.business_id', 
	business_name nvarchar(500) '$.name', 
	neighborhood nvarchar(100) '$.neighborhood',
	business_address nvarchar(1000) '$.address',
	business_city nvarchar(500) '$.city',
	business_state varchar(500) '$.state',
	postal_code varchar(100) '$.postal_code',
	latitude float '$.latitude',
	longitude float '$.longitude',
	stars float '$.stars',
	review_count int,
	is_open bit,
	attributes nvarchar(max) AS JSON,
	categories nvarchar(max) '$.categories' AS JSON,
	business_hours nvarchar(max) '$.hours' AS JSON,
	item_type varchar(100) '$.type'
	) as Business
GO

DROP TABLE IF EXISTS Tip
GO

SELECT 
	tip_text,
	tip_date,
	likes,
	business_id,
	user_id 
INTO Tip
FROM OPENROWSET (BULK 'C:\Yelp\tip.json'
	,FORMATFILE = 'C:\Yelp\xml\linebyline.xml'
	,CODEPAGE = '65001') as j
 CROSS APPLY OPENJSON(SingleLine)
 WITH( 
	tip_text nvarchar(max) '$.text', 
	tip_date date '$.date', 
	likes int,
	business_id varchar(100) '$.business_id', 
	[user_id] varchar(100) '$.user_id', 
	item_type varchar(100) '$.type'
	) as Tip
GO

DROP TABLE IF EXISTS YelpUser
GO

SELECT 
	user_id
	,user_name
	,review_count
	,yelping_since
	,friends
	,is_useful
	,is_funny
	,is_cool
	,fans
	,elite
	,average_stars
	,compliment_hot
	,compliment_more
	,compliment_profile
	,compliment_cute
	,compliment_list
	,compliment_note
	,compliment_plain
	,compliment_cool
	,compliment_funny
	,compliment_writer
	,compliment_photos
INTO YelpUser
FROM OPENROWSET (BULK 'C:\Yelp\user.json'
	,FORMATFILE = 'C:\Yelp\xml\linebyline.xml'
	,CODEPAGE = '65001') as j
 CROSS APPLY OPENJSON(SingleLine)
 WITH( 
	[user_id] varchar(100) '$.user_id', 
	user_name nvarchar(1000) '$.name', 
	review_count int,
	yelping_since date, 
	friends nvarchar(max) as JSON, 
	is_useful bit '$.useful',
	is_funny bit '$.funny',
	is_cool bit '$.cool',
	fans int,
	elite nvarchar(max) as JSON, 
	average_stars float,
	compliment_hot int,
	compliment_more int,
	compliment_profile int,
	compliment_cute int,
	compliment_list int,
	compliment_note int,
	compliment_plain int,
	compliment_cool int,
	compliment_funny int,
	compliment_writer int,
	compliment_photos int,
	item_type varchar(100) '$.type'
	) as YelpUser
GO

DROP TABLE IF EXISTS Review
GO

SELECT 
	review_id
	,[user_id]
	,business_id
	,stars
	,[review_date] 
	,[review_text] 
	,is_useful
	,is_funny
	,is_cool
INTO Review
 FROM OPENROWSET (BULK 'C:\Yelp\review.json'
	,FORMATFILE = 'C:\Yelp\xml\linebyline.xml'
	,CODEPAGE = '65001') as j
 CROSS APPLY OPENJSON(SingleLine)
 WITH( 
	review_id varchar(100) '$.review_id', 
	[user_id] varchar(100) '$.user_id', 
	business_id varchar(100) '$.business_id',
	stars float '$.stars',
	[review_date] date '$.date',
	[review_text] nvarchar(max) '$.text',
	is_useful bit '$.useful',
	is_funny bit '$.funny',
	is_cool bit '$.cool',
	[item_type] varchar(100) '$.type') as Review
GO

DROP TABLE IF EXISTS BusinessCategory;
GO

SELECT Business.business_id,
       category.value AS category
INTO   BusinessCategory
FROM   Business CROSS APPLY OPENJSON (categories) AS category;
GO

DROP TABLE IF EXISTS YelpUserFriend;
GO

SELECT user_id,
       userfriend.value AS friend_user_id
INTO   YelpUserFriend
FROM   YelpUser CROSS APPLY OPENJSON (friends) AS userfriend;
GO