library(shiny)
library(lightgbm)
library(shinythemes) # For a better look

# =========================
# LOAD MODEL
# =========================
# Ensure the model file is in the same folder as app.R
model_lgb <- readRDS("model_lgb.rds")

# =========================
# UI
# =========================
ui <- fluidPage(
  theme = shinytheme("flatly"), # Using a modern professional theme
  
  titlePanel("📊 Student Success Predictor (AI Optimized)"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Student Demographics"),
      numericInput("G1", "First Period Grade (G1):", 12, min = 0, max = 20),
      numericInput("G2", "Second Period Grade (G2):", 12, min = 0, max = 20),
      
      hr(), # Visual separator
      h4("Habits & Background"),
      sliderInput("studytime", "Weekly Study Time (1-4 hrs):", 1, 4, 2),
      sliderInput("absences", "Expected Absences:", 0, 93, 2),
      selectInput("subject", "Subject:", choices = c("Math" = "math", "Portuguese" = "portuguese")),
      
      hr(),
      h4("Family & Lifestyle"),
      selectInput("higher", "Wants Higher Education?", choices = c("Yes" = 1, "No" = 0)),
      numericInput("Medu", "Mother's Education (0-4):", 2, min = 0, max = 4),
      numericInput("Fedu", "Father's Education (0-4):", 2, min = 0, max = 4),
      sliderInput("alc", "Alcohol Consumption (Combined 2-10):", 2, 10, 2),
      
      actionButton("predict", "Generate AI Prediction", class = "btn-primary btn-lg", width = "100%")
    ),
    
    mainPanel(
      wellPanel(
        h3("Final Grade Forecast", align = "center"),
        h1(textOutput("grade"), align = "center", style = "color: #2c3e50; font-weight: bold;"),
        h3(textOutput("status"), align = "center", style = "font-weight: bold;")
      ),
      
      hr(),
      h4("Model Insight"),
      p("This prediction is generated using a Gradient Boosted Machine (LightGBM) optimized for student performance tracking. It considers academic history, social habits, and family background.")
    )
  )
)

# =========================
# SERVER
# =========================
server <- function(input, output) {
  
  observeEvent(input$predict, {
    
    # 1. Define the EXACT 12 features your model was trained on
    # Order matters for LightGBM!
    model_cols <- c("G1", "G2", "studytime", "failures", "absences_log", 
                    "total_alc", "parent_edu", "subjectmath", "subjectportuguese", 
                    "higheryes", "internetyes", "romanticyes")
    
    # 2. Create the dataframe and ensure names match 'model_cols'
    new_student <- data.frame(
      G1 = input$G1,
      G2 = input$G2,
      studytime = input$studytime,
      failures = 0, 
      absences_log = log1p(input$absences),
      total_alc = input$alc, 
      parent_edu = input$Medu + input$Fedu,
      subjectmath = ifelse(input$subject == "math", 1, 0),
      subjectportuguese = ifelse(input$subject == "portuguese", 1, 0),
      higheryes = as.numeric(input$higher),
      internetyes = 1,
      romanticyes = 0 
    )
    
    # 3. Add any of the 12 features that might be missing from the DF
    for (col in model_cols) {
      if (!col %in% names(new_student)) {
        new_student[[col]] <- 0
      }
    }
    
    # 4. FORCE the order to match 'model_cols'
    # This ensures the matrix has exactly 12 columns in the right order
    final_input_df <- new_student[1, model_cols, drop = FALSE]
    
    # DEBUG: This should now show 12
    print(paste("Number of features being sent:", ncol(final_input_df)))
    print(colnames(final_input_df))
    
    # 5. Convert to Matrix and Predict
    new_matrix <- data.matrix(final_input_df)
    
    pred <- predict(model_lgb, new_matrix)
    pred <- max(0, min(20, pred))
    
    # 6. Render
    output$grade <- renderText({ paste(round(pred, 2)) })
    output$status <- renderText({ ifelse(pred >= 10, "PASS ✅", "FAIL ❌") })
  })
}
# =========================
# RUN APP
# =========================
shinyApp(ui, server)