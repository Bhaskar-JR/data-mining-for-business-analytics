# 
# Title:    lead scoring test
# Purpose:  (Sales) Testing what I can pull from the Yelp API 
# Author:   Billy Caughey 
# Date:     2020.06.23 - Initial Build 
# 

##### Set up options #####

options(stringsAsFactors = F)

##### Libraries #####

#devtools::install_github("OmaymaS/yelpr")
#devtools::install_github("mrdwab/SOfun")
library(yelpr)
#library(SOfun)
library(tidyverse)
library(googledrive)
library(googlesheets)
library(googleCloudStorageR)
library(googleAuthR)

##### Client ID and Secret #####

client_id <- "npqOLtu_00NSw7XsRGS_3A"
client_secret <- "sWj-ym9TKBh0PJD1zDO_8-6ICJ0KDwkuIYdn-VRkgCOAyomG_P1WpwdQelU4u8qmxpKTfASROsyu9vgQIvjgpkiz7bJcYGTf35ZOw4qpv96th9LH54bCJL1O9RLyXnYx"

key <- client_secret

##### Run #####

offset_num <- seq(0, 950, by = 50)

concrete_dallas_tx <- NULL

for(i in 1:length(offset_num)){

  print(offset_num[i] + 50)
  
  pro_list <- business_search(api_key = client_secret,
                              location = "Dallas, TX",
                              radius = 40000,
                              categories = "masonry_concrete",
                              limit = 50,
                              offset = offset_num[i])
  
  if(length(pro_list$businesses) > 0){
    
    x1 <- tibble(id = pro_list$businesses$id,
                 alias = pro_list$businesses$alias,
                 biz_name = pro_list$businesses$name,
                 image_url = pro_list$businesses$image_url,
                 is_closed = pro_list$businesses$is_closed,
                 url = pro_list$businesses$url,
                 review_count = pro_list$businesses$review_count,
                 ratings = pro_list$businesses$rating,
                 latitude = pro_list$businesses$coordinates$latitude,
                 longitude = pro_list$businesses$coordinates$longitude,
                 address1 = pro_list$businesses$location$address1,
                 address2 = pro_list$businesses$location$address2,
                 address3 = pro_list$businesses$location$address3,
                 city = pro_list$businesses$location$city,
                 zip_code = pro_list$businesses$location$zip_code,
                 phone = pro_list$businesses$phone,
                 display_phone = pro_list$businesses$display_phone) 
    
    pro_cats <- NULL
    
    for(j in 1:nrow(pro_list$businesses)){
      
      
      x3 <- tibble(id = pro_list$businesses$id[j],
                   category1 = data.frame(pro_list$businesses$categories[j])$title[1],
                   category2 = data.frame(pro_list$businesses$categories[j])$title[2],
                   category3 = data.frame(pro_list$businesses$categories[j])$title[3],
                   category4 = data.frame(pro_list$businesses$categories[j])$title[4],
                   category5 = data.frame(pro_list$businesses$categories[j])$title[5],
                   category6 = data.frame(pro_list$businesses$categories[j])$title[6],
                   category7 = data.frame(pro_list$businesses$categories[j])$title[7],
                   category8 = data.frame(pro_list$businesses$categories[j])$title[8],
                   category9 = data.frame(pro_list$businesses$categories[j])$title[9],
                   category10 = data.frame(pro_list$businesses$categories[j])$title[10])
      
      pro_cats <- rbind(pro_cats, x3)
      
    }
    
    
    concrete_dallas_tx <- rbind(concrete_dallas_tx, 
                                x1 %>% 
                                  left_join(y = pro_cats, by = "id"))
    
  }
  
  else{
    
    break
    
  }
   

}

##### Save Data #####

write.csv(x = concrete_dallas_tx,
          file = "/Users/wcaughey/Documents/data sets/yelp scrape - 20200623.csv",
          row.names = FALSE)

drive_upload(media = "/Users/wcaughey/Documents/data sets/yelp scrape - 20200623.csv", 
             name = "yelp scrape - 20200623", 
             type = "spreadsheet")

drive_mv(file = "yelp scrape - 20200623", path = "~/Sales/Lead Scoring and Revenue Sizing/")
