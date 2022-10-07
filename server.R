## Shiny Server component for dashboard

function(input, output, session){
  
  # Data table Output
  output$dataT <- renderDataTable(my_data)

  
  # Rendering the box header  
  output$head1 <- renderText(
    paste("5 states with high rate of", input$var2, "Arrests")
  )
  
  # Rendering the box header 
  output$head2 <- renderText(
    paste("5 states with low rate of", input$var2, "Arrests")
  )
  
  
  # Rendering table with 5 states with high arrests for specific crime type
  output$top5 <- renderTable({
    
    my_data %>% 
      select(State, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      head(5)
    
  })
  
  # Rendering table with 5 states with low arrests for specific crime type
  output$low5 <- renderTable({
    
    my_data %>% 
      select(State, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      head(5)
    
    
  })
  
  
  # For Structure output
  output$structure <- renderPrint({
    my_data %>% 
      str()
  })
  
  
  # For Summary Output
  output$summary <- renderPrint({
    my_data %>% 
      summary()
  })
  
  # For histogram - distribution charts
  output$histplot <- renderPlotly({
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(x=~get(input$var1)) %>% 
      layout(xaxis = list(title = paste(input$var1)))
    
    
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # stacking the plots on top of each other
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title="Frequency"))
  })
  
  
  ### Bar Charts - State wise trend
  output$bar <- renderPlotly({
    my_data %>% 
      plot_ly() %>% 
      add_bars(x=~State, y=~get(input$var2)) %>% 
      layout(title = paste("Statewise Arrests for", input$var2),
             xaxis = list(title = "State"),
             yaxis = list(title = paste(input$var2, "Arrests per 100,000 residents") ))
  })
  
  
  ### Scatter Charts 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      ggplot(aes(x=get(input$var3), y=get(input$var4))) +
      geom_point() +
      geom_smooth(method=get(input$fit)) +
      labs(title = paste("Relation b/w", input$var3 , "and" , input$var4),
           x = input$var3,
           y = input$var4) +
      theme(  plot.title = element_textbox_simple(size=10,
                                                  halign=0.5))
      
    
    # applied ggplot to make it interactive
    ggplotly(p)
    
  })
  
  
  ## Correlation plot
  output$cor <- renderPlotly({
    my_df <- my_data %>% 
      select(-State)
    
    # Compute a correlation matrix
    corr <- round(cor(my_df), 1)
    
    # Compute a matrix of correlation p-values
    p.mat <- cor_pmat(my_df)
    
    corr.plot <- ggcorrplot(
      corr, 
      hc.order = TRUE, 
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
    
  })
  
  
    # Interpretasi
  
  output$interpretasi <- renderText({
    paste(
      "Interpretasi Dari Visualisasi Data
      
  1. Pada distribusi tersebut terlihat ada histogram dan boxplot. pada boxplot terlihat tidak ada outlier, 
  tetapi tidak membagi box tersebut menjadi dua secara sama rata atau cenderung banyak ke kanan sehingga data tersebut 
  bisa dikatakan diduga tidak berdistribusi normal. 
  
  2. Lalu pada histogram menjelaskan banyaknya murder dengan frekuensi jika dibayangkan menggunakan density plot 
  maka data tersebut tidak berdistribusi normal karena memiliki skewness ke kanan atau condong tinggi ke kiri.

  3. Pada bar graph tersebut kita bisa membandingkan beberapa kota dengan angka jumlah pembunuhan. 
  Disana bisa kita lihat bahwa terdapat kota dengan angka pembunuhan terbesar yaitu kota florida 
  karena memiliki batang yang lebih tinggi. Lalu terdapat angka pembunuhan terkecil yaitu negara hawai 
  karena dilihat dari bar graph tersebut, kota hawai memiliki angka pembunuhan rata-rata dibawah frekuensi 5.

  4. Pada tabel korelasi kita bisa melihat terdapat korelasi yang searah pada variabel urbanpop, rape, murder dan asault 
  karena angkanya berupa positif. Terdapat korelasi yang kuat atau antara 2 variabel tersebut 
  saling berkaitan yaitu variabel murder dan assault dengan angka korelasi pearsonnya adalah 0,8. Sehinnga 
  jika nilai assault semakin besar maka nilai murder juga semakin besar. 
  Lalu terdapat korelasi yang lemah atau kurang berkaitan antara 2 variabel tersebut yaitu 
  variabel murder dan variabel urban pop dengan angka korelasi pearsonnya adalah 0,1.

  5. Pada scatter plot tersebut kita bisa mengetahui bahwa plot antar variabel tersebut cenderung berhubungan
  searah karena semuanya memiliki angka korelasi positif. Seperti contohnya hubungan antara variabel assault
  dan murder pada scatter plot tersebut. Sehingga semakin banyak nilai assault maka semakin banyak nilai murder pula.
  Sehingga kita bisa membuat regresi linier pada plot tersebut yang berupa garis lurus dari bawah kiri hingga ke kanan
  atas. Disana terdapat smooth method yang berupa lm dan loess. Lm berupa garis prediksi lurus. Untuk loess berupa
  garis prediksi melengkung yang merupakan jenis regresi lokal."
    )
    
    
    
    
    
  })
  
  
  
  
}

