    CREATE DATABASE [yelp] ON  PRIMARY 
    ( NAME = N'yelp_Data', FILENAME = N'D:\yelp_db\MSSQL\Data\yelp_Data.mdf' , SIZE = 167872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 16384KB )
     LOG ON 
    ( NAME = N'yelp_Log', FILENAME = N'D:\yelp_db\MSSQL\Log\yelp_Log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 16384KB )