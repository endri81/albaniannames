require(ggplot2)
require(shiny)
require(dplyr)
require(wordcloud)

# Load the dataset
loadData <- function() {
  maintable<- read.csv("./data/maintable.csv")
  popullariteti <- read.csv("./data/popullariteti.csv")
  wordcloud <- read.csv("./data/wordcloud.csv")
  df <- list(maintable, popullariteti, wordcloud)
  return(df)
}

# # Plot the wordcloud

getWordCloud <- function(df, reaction){
  dfs<-df[[3]]
  stateName = reaction$stateName
  year = reaction$year
  wordNumber = reaction$wordNumber
  if (reaction$sexChoose == "Femër"){
    sexChoose = "F"
  }
  else {sexChoose = "M"}
  if (stateName == "All"){
    indices <- which(dfs$Year == year & dfs$Sex == sexChoose)
    new_df <- dfs[indices, ]
    new_df <- aggregate(Number ~ Sex+Year+Name, new_df, sum)
    cloud_df <- head(new_df[sort.list(new_df$Number, decreasing=TRUE),], wordNumber)
  }
  else {
    indices <- which(dfs$State == stateName & dfs$Year == year & dfs$Sex == sexChoose)
    cloud_df <- head(dfs[indices, ][sort.list(dfs[indices, ]$Number, decreasing=TRUE),], wordNumber)
  }
  set.seed(375) # to make it reproducibles
  # plot the word cloud
  return(wordcloud(words = cloud_df$Name, freq = cloud_df$Number,
                   scale = c(8, 0.4),
                   min.freq = 1,
                   random.order = FALSE,
                   rot.per = 0.15,        
                   colors = brewer.pal(8, "Dark2"),
                   random.color = TRUE,
                   use.r.layout = FALSE    
  )) # end return
} # end getWordCloud

# Plot comparision
getCompare<- function(df, reaction){
  dfs<-df[[3]]
  radio = reaction$radio
  new_df1 <- filter(dfs, dfs$State == radio)
  new_df2 <- new_df1 %>% group_by(Year, Sex) %>%  slice(which.max(Percent)) 
  
  g2 <- ggplot(new_df2, aes(x=Year, y= Percent, fill= Name)) +
    geom_bar(aes(width=.80),stat="identity") +
    xlab("Viti") +
    ylab("Përqindja") 
  return(g2)
}


# Plot popularity
getGraph <- function(df, reaction){
  popullariteti<-df[[2]]
  g1 <- popullariteti %>% filter(name == reaction$name) %>% 
    ggplot(., aes(year, n)) +
    geom_line(aes(color=sex), lwd=1) +
    theme_bw() +
    ggtitle(reaction$name) + scale_colour_discrete(name  ="Gjinia", labels=c("Femra", "Meshkuj")) +
    xlab("Viti") +
    ylab("Numri") + 
    scale_x_continuous(breaks = round(seq(min(popullariteti$year), max(popullariteti$year), by = 10),1)) + 
    theme(
      axis.text = element_text(size = 14),
      legend.key = element_rect(fill = "white"),
      legend.background = element_rect(fill = "white"),
      legend.position = c(0.14, 0.80),
      panel.grid.major = element_line(colour = "grey40"),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "navy")
    )
  return(g1)
}

# Plot the results
getResult <- function(df, reaction){
  maintable <- df[[1]]
  kerkimemri = reaction$kerkimemri
  if (reaction$gender == "Femër"){
    gender = "F"
  }
  else {gender = "M"}
  new_df <- maintable %>% filter(maintable$Emri == kerkimemri &  maintable$Gjinia == gender)
  
if(nrow(new_df) == 0)
  
  {text1 <- "Nuk u gjet asnjë person me këtë emër"}

  else if(new_df$Frekuenca <=9)  

    {text1 <- "Ka më pak se 10 persona me këtë emër" } 
else 
  
  {text1<-paste("U gjendën", new_df$Frekuenca, "persona me emrin", kerkimemri)}
  
  return(text1)
}


##### GLOBAL OBJECTS #####

# Shared data
globalData <- loadData()

##### SHINY SERVER #####
# Create shiny server.
shinyServer(function(input, output) {
  cat("Press \"ESC\" to exit...\n")
  # Copy the data frame 
  localFrame <- globalData
  

  getReactionWordCloud <- reactive({
    return(list(stateName = input$stateName1,
                year = input$year1,
                sexChoose = input$sexChoose1,
                wordNumber = input$wordNumber1
    ))
  })
  
  getReactionComp <- reactive({
    return(list(stateName = input$stateName1,
                radio = input$radio
    ))
  })
  
  getReactionSearch <- reactive({
    return(list(
      name = input$nameSearch2
    ))
  })
  
  getReactionMain <- reactive({
    return(list(
                gender = input$kerkimgjinia,
                kerkimemri = input$kerkimemri
    ))
  })
  # Output Plots.
  output$wordCloud <- renderPlot({print(getWordCloud(localFrame, getReactionWordCloud()))},width=1000,height=800) # output wordCloud
  output$g2 <- renderPlot({print(getCompare(localFrame, getReactionComp()))},width=1000,height=600) # output comparision
  output$g1 <- renderPlot({print(getGraph(localFrame, getReactionSearch()))},width=1000,height=600) # output namesearch
  output$text1 <- renderText({print(getResult(localFrame, getReactionMain()))}) # output namesearch
  output$downloadData1 <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), './data/top10v2014.xlsx', sep='')
    },
    content = function(con) {
      write.csv(data, con)
    }
  )
  output$downloadData2<- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), './data/top10qark.xlsx', sep='')
    },
    content = function(con) {
      write.csv(data, con)
    }
  )
}) # shinyServer