## Shiny UI component for the Dashboard

dashboardPage(
  
  dashboardHeader(title="Dashboard Kelompok 2 Bismillah Dapat A", titleWidth = 450),
  
  
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
      menuItem("Dataset", tabName = "data", icon = icon("database")),
      menuItem("Visualization", tabName = "viz", icon=icon("chart-line")),
      
      # Conditional Panel for conditional widget appearance
      # Filter should appear only for the visualization menu and selected tabs within it
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable" , choices = c1)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Select the Arrest type" , choices = c2)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Select the X variable" , choices = c1, selected = "Rape")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var4" , label ="Select the Y variable" , choices = c1, selected = "Assault")),
      menuItem("Interpretation", tabName = "interpretasi", icon=icon("map"))
      
    )
  ),
  
  
  dashboardBody(
    
    tabItems(
      ## First tab item
      tabItem(tabName = "data", 
              tabBox(id="t1", width = 12, 
                     tabPanel("About", icon=icon("address-card"),
fluidRow(
  column(width = 8, tags$img(src="crime.jpg", width =600 , height = 300),
         tags$br() , 
         tags$a("Photo by Campbell Jensen on Unsplash"), align = "center"),
  column(width = 4, tags$br() ,
         tags$p("This data set includes; USA Arrests. Data ini didapat dari kaglle. 
                data ini merupakan informasi mengenai kejadian kriminal tiap kota di negara Amerika 
                yang terdiri dari pembunuhan, pemerkosaan, serangan tiba-tiba dan perilaku buruk masyarakat kota")
  )
)

                              
                              ), 
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted")),
                     tabPanel("Summary Stats", verbatimTextOutput("summary"), icon=icon("chart-pie"))
              )

),  
    
# Second Tab Item
    tabItem(tabName = "viz", 
            tabBox(id="t2",  width=12, 
                   tabPanel("Crime Trends by State", value="trends",
                            fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                     tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                                     
                            ),
                            withSpinner(plotlyOutput("bar"))
                   ),
            tabPanel("Distribution", value="distro",
                     withSpinner(plotlyOutput("histplot", height = "350px"))),
            tabPanel("Correlation Matrix", id="corr" , withSpinner(plotlyOutput("cor"))),
            tabPanel("Relationship among Arrest types & Urban Population", 
                     radioButtons(inputId ="fit" , label = "Select smooth method" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE), 
                     withSpinner(plotlyOutput("scatter")), value="relation"),
            side = "left"
                   ),
            
            
            ),

   
    # Third Tab Item
      tabItem(
      tabName = "interpretasi",
        fluidRow(
          verbatimTextOutput(outputId = "interpretasi")
        )


      
    )

)
    )
  )

  
  
