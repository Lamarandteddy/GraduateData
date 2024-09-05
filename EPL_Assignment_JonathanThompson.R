
# Importing tidyverse library
library(tidyverse)

EPL_Standings <- function(date,season){
  
  # Converting date type as mm/dd/yyyy:
  date <- as.Date(date,format = '%m/%d/%Y')
  
  # Setting formatted season
  seasons <- paste0(substr(season,3,4), substr(season,6,7),'/')
  
  # URL to download any specific season format of Premier League
  url <- paste0('https://www.football-data.co.uk/mmz4281/',seasons,'E0.csv')
  
  # Assigning to read csv file
  primary <- read_csv(url)
  
  # Listing subset
  df <- primary %>%
    select(Date, HomeTeam, AwayTeam, FTHG, FTAG,FTR) %>%
    
    # Mutate function to list YYYY year format
    mutate(year = ifelse(nchar(Date) == 10,substring(Date,9,10),
                         ifelse(nchar(Date) == 8,substring(Date,7,8))),
           Date = paste0(substring(Date,1,6),year),
           Date1 = as.Date(Date,format = '%d/%m/%y')) %>% 
    
   #  Filter and mutate function in order to list up to certain date
    filter(Date1 <= date) %>%
    mutate(home_match_points = ifelse(FTR == 'D', 1, ifelse(FTR == 'H', 3, ifelse(FTR == 'A', 0,NA))), # home points
           away_match_points = ifelse(FTR == 'D', 1, ifelse(FTR == 'H', 0, ifelse(FTR == 'A', 3,NA))), # away points
           home_match_wins = ifelse(FTR == 'H',1,0), # if home win, count as 1
           away_match_wins = ifelse(FTR == 'A', 1,0), # if away win, count as 1
           home_match_draws = ifelse(FTR == 'D',1,0), # if home draw, count as 1
           away_match_draws= ifelse(FTR == 'D',1,0), # if away draw, count as 1
           home_match_loss = ifelse(FTR == 'A',1,0), # if home loss, count as 1
           away_match_loss = ifelse(FTR == 'H',1,0)) # if away loss, count as 1
  
  # Subset creation for home matches
  home_matches <- df %>%
    select(Date, HomeTeam, FTHG,FTAG, FTR,Date1,home_match_points, home_match_draws,home_match_wins,home_match_loss) %>%
    group_by(TeamName = HomeTeam) %>% 
    summarize(home_match_count = n(), 
              home_match_points = sum(home_match_points), 
              home_match_wins = sum(home_match_wins), 
              home_match_draws = sum(home_match_draws), 
              home_match_losses = sum(home_match_loss), 
              home_match_goals_for = sum(FTHG), 
              home_match_goals_against = sum(FTAG)) 
  
  # subset creation for away matches
  away_matches <- df %>%
    select(Date, Date1, AwayTeam, FTHG,FTAG, FTR, away_match_points, away_match_wins, away_match_draws, away_match_loss) %>%
    group_by(TeamName = AwayTeam) %>% 
    summarize(away_match_count = n(), 
              away_match_points = sum(away_match_points), 
              away_match_wins = sum(away_match_wins), 
              away_match_draws = sum(away_match_draws), 
              away_match_losses = sum(away_match_loss), 
              away_match_goals_for = sum(FTAG), 
              away_match_goals_against = sum(FTHG)) 
  
  # Full join method to join both home and away matches
  join_set <- home_matches %>%
    full_join(away_matches, by = c('TeamName'))
  
  # Converting null values to 0
  join_set[is.na(join_set)] <- 0
  
  # Creating of columns in order to list statistics
  join_df <- join_set %>%
    mutate(MatchesPlayed = home_match_count + away_match_count, 
           Points = home_match_points + away_match_points, 
           PPM = Points/MatchesPlayed,3, 
           PtPct =Points/(3*MatchesPlayed),2,
           Wins = home_match_wins + away_match_wins, 
           Draws = home_match_draws + away_match_draws, 
           Losses = home_match_losses + away_match_losses, 
           Record = paste0(Wins,'-',Losses,'-',Draws), 
           HomeRec = paste0(home_match_wins,'-',home_match_losses,'-',home_match_draws), 
           AwayRec = paste0(away_match_wins,'-',away_match_wins,'-',away_match_wins),
           GS = home_match_goals_for + away_match_goals_for, 
           GSM =GS/MatchesPlayed,2, 
           GA = home_match_goals_against + away_match_goals_against, 
           GAM =GA/MatchesPlayed,2) 
  
  final_df <- join_df %>%
    arrange(desc(PPM), desc(Wins),desc(GSM),GAM) %>%
    select(TeamName, Record, HomeRec,AwayRec,MatchesPlayed,Points,PPM,PtPct,GS,GSM,GA,GAM)
  return(final_df)
}
  
#EPL_Standings listed for specified date and season
EPL_Standings("04/25/2022", "2021/22") 
print(EPL_Standings("04/25/2022", "2021/22"))