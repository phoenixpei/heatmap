library(shiny)
library(rCharts)
library(rjson)
library(xlsx)


############################################################################################################
#### data prep
####
############################################################################################################

# # read in JSON data and convert to data frame
##dat <- rjson::fromJSON(file="C:/Bitnami/wampstack-5.4.37-0/apache2/htdocs/verizon/VCDB/heatmap_vz/heatmap-data.json")
dat <- rjson::fromJSON(file='/PRO/CODES/VCDB/VZApp/heatmap-data.json')
dat <- lapply(dat, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})
 
# rnames <- mydata3[,1]                            # assign labels in column 1 to "rnames"
# data3 <- data.matrix(mydata3[,2:ncol(mydata3)])  # transform column 2-5 into a matrix
# rownames(data3) <- rnames                  # assign row names 

dat <- matrix(dat$data, ncol=3, byrow=TRUE)
colnames(dat) <- c("x","y","value")

mydata1 <- read.xlsx("/PRO/CODES/VCDB/VZApp/data.xlsx", 1)

############################################################################################################

shinyServer(
  function(input, output, session) {
  
  # Highcharts Heat Map
  output$heatmap <- renderChart2({
    map <- Highcharts$new()
    map$chart(zoomType = "x", type = 'heatmap')
    map$credits(text = "Created with rCharts and Highcharts", href = "http://rcharts.io")
    map$title(text='VCDB Incident/Breach Patterns By Industry')

    map$series(name = 'Breaches per Pattern',
         data = toJSONArray2(dat, json=FALSE),
         color = "#800080",
         dataLabels = list(
           enabled = TRUE,
           color = 'black',
           style = list(
              textShadow = 'none',
              HcTextStroke = NULL
           )
         ))
         
    map$xAxis(categories = c('Point of Sale', 'Crimeware', 'Privilege Misuse', 'Miscellaneous Error', 'Lost and Stolen Assets', 
      'Cyber-Espionage', 'Payment Card Simmers', 'Web Applications', 'Everything Else', 'Denial of Service'))

    map$yAxis(categories = c('Unknown', 'Wholesale Trade', 'Utilities', 'Real Estate and Rental and Leasing','Public Administration', 'Professional, Scientific, and Technical Services', 
                             'Other Services (except Public Administration)','Mining, Quarrying, and Oil and Gas Extraction', 'Management of Companies and Enterprises', 'information',
                             'Health Care and Social Assistance','Finance and Insurance', 'Educational Services', 'Construction', 'Arts, Entertainment, and Recreation',  
                             'Agriculture, Forestry, Fishing and Hunting', 'Administrative and Support and Waste Management and Remediation Services', 'Accommodation and Food Services'),
        title=list(text = ""))
        
    map$addParams(colorAxis = 
      list(
          min = 0,
          minColor='#ffffff',
          maxColor='#008080'
      )
    )

    map$legend(align='right',
         layout='vertical',
         margin=0,
         verticalAlign='top',
         y=25,
         symbolHeight=320)
           
    # custom tooltip
    map$tooltip(formatter = "#! function() { return '<b>' + this.series.xAxis.categories[this.point.x] + '</b><br><b>' +
                    this.point.value + '</b> incidents for <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>'; } !#")

        
    # set width and height of the plot and attach it to the DOM
    map$addParams(height = 400, width=1000, dom="heatmap")
    
    # save heatmap as HTML page heatmap.html for debugging
    #map$save(destfile = 'heatmap.html')
    
    # print map
    print(map)
  })
  
  output$chart1 <- renderChart({
    YEAR = input$year
    
    #     p1 <- rPlot(x = list(var = "pattern", sort = "count"), y = "count",
    #                 color = "industry", data = mydata1, type= 'bar')
    
    PATTERN = input$pattern
    pattern = subset(mydata1, pattern == PATTERN)
    p1 <- rPlot(count ~ year, color='industry', type = "line", data=pattern)
    p1$guides(y = list(min=0, title= ""))
    p1$guides(y = list(title= ""))
    p1$addParams(height = 300, dom = 'chart1')
    return(p1)
    
  })
  
})