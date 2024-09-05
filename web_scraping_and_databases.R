# Webscraping and Databases in R

# Webscraping -------------------------------------------------------------
library(tidyverse)
library(rvest)
library(httr)

# scrape academy award nominees from wikipedia
aa_films_raw <- read_html("https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture") %>% 
        html_table(fill = T)

aa_films <- do.call(bind_rows, aa_films_raw) %>% 
        select(Year = `Year of Film Release`, Film) %>% 
        filter(!is.na(Film)) %>% 
        mutate(Year = str_extract(Year, "^\\d{4}")) %>% 
        group_by(Year) %>% 
        mutate(winner_index = rank(row_number()),
               winner = ifelse(winner_index == min(winner_index), 1, 0)) %>% 
        select(-winner_index)


# scrape rotten tomatoes info for each film
rotten_tomatoes_scores <- data.frame(tomatometer = rep(NA, length(aa_films$Film)), 
                                     audience_score = rep(NA, length(aa_films$Film)))

for(i in seq_along(aa_films$Film)){
        
        # handle errors and continue looping
        tryCatch({

                # for each film title, convert to rotten tomatoes url suffix format
                film_url_suffix <- tolower(str_replace_all(aa_films$Film[i], "\\s", "_"))
                
                # build url
                rt_url <- paste0("https://www.rottentomatoes.com/m/", film_url_suffix)
                
                # null page contents object
                page <- NULL
                
                # scrape page info for url
                x <- GET(rt_url, add_headers('user-agent' = 'Student'))
                page <- read_html(x)
                
                # if page is null then create missing values
                if(is.null(page)){
                        rotten_tomatoes_scores$tomatometer[i] <- NA
                        rotten_tomatoes_scores$audience_score[i] <- NA
                        
                # if page was scrape successfully, then extract the ratings info     
                } else {
                        
                        ratings <- page %>% 
                                html_nodes(".mop-ratings-wrap__percentage") %>% 
                                html_text() %>% 
                                str_extract("\\d+")
                        
                        rotten_tomatoes_scores$tomatometer[i] <- ratings[1]
                        rotten_tomatoes_scores$audience_score[i] <- ratings[2]
                }
        
        print(i)
        }, error = function(e){cat("ERROR :", conditionMessage(e), "\n", "iteration ", i)})
                
}


# create film IDs
rotten_tomatoes_scores$Film_ID <- 1001:(1000+length(rotten_tomatoes_scores$Film))
aa_films$Film_ID <- 1001:(1000+length(aa_films$Film))

# Working with Databases --------------------------------------------------

library(DBI)
library(odbc)
library(RSQLite)
library(dbplyr)

# The dbConnect function from the DBI package allows us to create a SQLite database directly from R.
# SQLite databases are saved as files in the current working directory with this method. As described 
# in the RSQLite packge vignette, if you simply want to use a temporary database, you can create either 
# an on-disk database or an in-memory database with this same method. For this example, we will create 
# a new SQLite in-memory database.

# connect to a database (can be MYSQL, etc.)
con <- dbConnect(SQLite(), ":memory:")

# show tables in connected db
dbListTables(con)

# writing tables to a database
dbWriteTable(con, "aa_films", aa_films, overwrite = TRUE)
dbWriteTable(con, "film_ratings", rotten_tomatoes_scores)

# check that tables were written into db
dbListTables(con)

# query the database
df <- dbGetQuery(con, "SELECT * FROM aa_films WHERE winner == 1")



# Using dbplyr ------------------------------------------------------------

# in addition to querying a SQL database directly by passing SQL statements
# into the dbGetQuery function, the dbplyr package (related to dplyr) allows
# R users to qvoid having to write SQL queries at all.

# the dbplyr package allows users to create a reference to a sql table and 
# interact with it using dplyr verbs

# first create the reference to the sql table using tbl()
aa_films_tbl <- tbl(con, "aa_films")


# then use dplyr like normal
year_summary <- aa_films_tbl %>% 
        select(Film_ID, Film, Year, winner) %>% 
        filter(Year > 1945) %>% 
        group_by(Year, winner) %>% 
        count() 

# behind the scenes, dbplyr writes your SQL for you
year_summary %>% show_query()

# until you tell dbplyr to return the full query, using collect, it only evaluates the
# query lazily
year_summary <- aa_films_tbl %>% 
        select(Film_ID, Film, Year, winner) %>% 
        filter(Year > 1945) %>% 
        group_by(Year, winner) %>% 
        count() %>% 
        collect() %>% # collect is important because it returns the full query result
        as_tibble()

# now we can do some analysis if we want
