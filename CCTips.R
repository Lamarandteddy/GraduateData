library(caret)
library(tidyverse)

insurance<-read.csv("insurance_data.csv")

insurance<-insurance %>%
  mutate_at(c(5,86),as.factor)

ggplot(insurance, aes(response))+
  geom_bar(fill="blue", width=0.7)+
  labs(x="response",
           y="count")prop.table(table(insurance$response))
table(insurance$response, insurance@customer_main)

ggplot(insurance, aes(x=customer_main, fill=response)) +
  geom_bar()

ggplot(insurance, aes(x=customer_main, fill=response)) +
  geom_bar(position = "dodge")

resp_custmain <-table(insurance$response, insurance_custmain)

round(prop.table(resp_custmain,1),2)

ds<-insurance%>%
  group_by(response, customer_main)%>%
  summarise(n=n())%>%
  mutate(pct = 100*n/sum (n))

ggplot(ds, aes(x=customer_main, y=pct, fill=response))
  geom_col()
ggplot(ds, aes(x+response, y+pct)) +
  geom_bar(aes(fill=response, stat="identity")) +
  facet_wrap(~ customer_main) +
  label(x="Customer_Main", y="Percent")

