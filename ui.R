library(shiny)
library(readr)

bv_data = read_csv("BVanalysis_data.csv")
bv_bacteria_list = c("gvag", "bvab1", "bvab2", "bvab3", "atop", "mc", "ls",  "mega")
bv_only = subset(bv_data, bacteria %in% bv_bacteria_list)

ui <- fluidPage(
  titlePanel("Time series of BV-associated bacteria during BV treatment"),
  sidebarLayout(
    sidebarPanel(
      selectInput("bacteria_list", "Bacteria", unique(bv_only$bacteria_full),
                  selected = unique(bv_only$bacteria_full),
                  multiple = TRUE),
      selectInput("ID_list", "Patient ID", unique(bv_only$patient_id),
                  selected = unique(bv_only$patient_id),
                  multiple = TRUE)
    ),
    mainPanel(
      plotOutput("bacteria_ts", width = "100%")
    )
  )
)
