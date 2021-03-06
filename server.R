library(shiny)
library(readr)
library(RColorBrewer)
library(ggplot2)

bv_data = read_csv("BVanalysis_data.csv")
bv_data$log_count2 = ifelse(bv_data$detected, bv_data$log_count, 0)

bv_bacteria_list = c("gvag", "bvab1", "bvab2", "bvab3", "atop", "mc", "ls",  "mega")
bv_only = subset(bv_data, bacteria %in% bv_bacteria_list)


colour_data = data.frame(
  pid = unique(as.character(bv_data$patient_id)),
  colour = c(brewer.pal(12, "Paired"), brewer.pal(8, "Accent")[c(5,8)], "black")
)

theme_set =
  theme(
    panel.background = element_blank()
    ,panel.grid.minor = element_blank()
    ,text=element_text(family="Times")
    ,axis.line = element_line(colour = "black")
    ,axis.title = element_text(size=20)
    ,axis.text = element_text(size=16, colour="black")
    ,panel.border = element_rect(colour = "black")
    ,legend.position="none"
    ,axis.text.y =  element_text(size=20)
    ,strip.text.x=element_text(family="Times", size=12))

shinyServer(
  function(input, output){
    output$bacteria_ts = renderPlot({
      if(is.null(input$ID_list) | is.null(input$bacteria_list)){
        p = ggplot(data = data.frame(x = 1, y = 1),
                   aes(x = 1, y = 1)) +
          scale_y_continuous("log 16S rRNA gene copies/swab", breaks=seq(1, 10, 1))  +
          scale_x_continuous("Treatment Day", breaks=seq(0, 6, 1), limits=c(0, 6.1)) +
          geom_blank() + theme_bw() + theme_set +
          theme(axis.text = element_blank())
      } else{
        p = ggplot(data = subset(bv_only, patient_id %in% input$ID_list &
                               bacteria_full %in% input$bacteria_list),
               aes(x = study_day, y = log_count2, colour = patient_id)) +
          geom_line(size = 1.5, alpha = 0.8) +
          facet_wrap(~ bacteria_full, ncol=4) +
          scale_y_continuous("log 16S rRNA gene copies/swab", breaks=seq(1, 10, 1))  +
          scale_x_continuous("Treatment Day", breaks=seq(0, 6, 1), limits=c(0, 6.1)) +
          scale_colour_manual(guide = F,
                              values = subset(colour_data, pid %in% input$ID_list)$colour) +
          theme_bw() + theme_set
      }
      print(p)
      }, height = 500)
    }
)
