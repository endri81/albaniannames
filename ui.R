library(shiny)
library(htmlwidgets)
library(shinydashboard)

shinyUI(navbarPage("",
                   tabPanel("Head",
                            
                     fluidRow(
                       
                       column(4,
                                  textInput("kerkimemri", "Search Name: ", ""),
                                  br(), 
                                  radioButtons("kerkimgjinia", "Gender:", c("Female", "Male"),
                                               selected = c("Female"))
                       ),
                       
                       column(4, strong("Search Result"),
                              br(),
                              br(),
                              textOutput("text1"),
                              tags$head(tags$style("#text1{color: blue;
                                 font-size: 16px;
                                 font-style: bold;
                                 }"
                              ))
                       ),     
                      
                       column(4,
                   
                                     
                              includeHTML("./www/table1.Rhtml")
                        )
                   )
                   ), 
                   tabPanel("Top 10",
                            
                            fluidRow(
                              
                              column(6,
                                     
                                     img(src = "Femra.jpg", height = 680, width = 850),
                                     downloadLink('downloadData1', 'Here you can download data:')
                                     
                              ),
                              
                              column(6,
                                     
                                     img(src = "Meshkuj.jpg", height = 680, width = 850),
                                     downloadLink('downloadData2', 'Here you can download data:')

                              )
                            )
                            
                   ), 
                   tabPanel("NameCloud",
                            fluidRow(                           
                              column(4, selectInput("stateName1","Region: ",
                                                    c("BERAT", "DIBER", "DURRES", "ELBASAN",  "FIER",  "GJIROKASTER",  "KORCE", "KUKES",  "LEZHE",  "SHKODER", "TIRANE", "VLORE"),
                                                    selected="All"),
                                     
                                     br(),
                                                selectInput("year1","Year: ",
                                                            c(2011,2012,2013,2014),
                                                            selected=2011),
                                                br(), 
                                                sliderInput("wordNumber1", "Numbers of word in cloud: ", min=50, max=100, value=100, step=1),
                                                br(),
                                                radioButtons("sexChoose1", "Gender:", c("Female", "Male"),
                                                             selected = c("Female")),
                                                br()
                                                
                              ),
                              column(8, 
                                     plotOutput("wordCloud",width="100%",height="100%")
                                     
                              )
                            )
                            
                            
                   ),
                   
                   
                   tabPanel("Comparision",
                            fluidRow(
                              column(4, selectInput("radio","Region: ",
                                                    c("BERAT", "DIBER", "DURRES", "ELBASAN",  "FIER",  "GJIROKASTER",  "KORCE", "KUKES",  "LEZHE",  "SHKODER", "TIRANE", "VLORE"),
                                                    selected="All"),
                                     
                                     br()
                              ),
                              
                              column(8,
                                     plotOutput("g2", width = "100%"))
                              )
                            
                   ),
                   
                   tabPanel("Popularity",
                            fluidRow(
                              column(4,
                                     img(src = "bebe.png", height = 240, width = 220),
                                     
                                     br(),
                                     br(),
                                     
                                     p("Compare popularity during years"),
                                     
                                     textInput("nameSearch2", "Search: ", ""),
                                     p("Please enter capital letters"),
                                     br(),
                                     
                                     downloadLink('', 'Data from Albanina Institute of Statistics, on 1 Tetor 2011, 
                                      
                                                  Census Data')
                             
     ), #end of sidebarPanel
                                    
column(8, 
       
       plotOutput("g1", width = "100%"))
                            
                   )
                   
                   
),
tabPanel("Help",
         fluidRow(
           column(4,
                  includeMarkdown("help.Rmd")
           )
         )
         )
)
)