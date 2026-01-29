# Script for sentiment analysis with LLM
# January 2026


## Preparations for working with model/ollamar

# install.packages("ollamar")

library(ollamar)
library(readr)
library(jsonlite)

# Load CSV and check if works
df <- read_csv("emotion_sentences.csv")
class(df)
test_connection()  # test connection to Ollama server

# download model
pull("llama3.2:1b")

# test: generate a response/text based on a prompt; returns an httr2 response by default
resp <- generate("llama3.2:1b", "tell me a 5-word story")
resp

# get just the text from the response object
resp_process(resp, "text")

# get the text as a tibble dataframe
resp_process(resp, "df")

# list available models (models you've pulled/downloaded)
list_models()




## Sentiment analysis with llama3.2:1b

# Load file without categories
df <- read_csv("emotion_sentences.csv")

# define model name
model_name <- "llama3.2:1b"
# pull(model_name)  # if not pulled before


# prompt

emotion_prompt <- function(sentence) {
  paste0(
    "You are a strict emotion classifier. 

IMPORTANT RULES:
1. Pick EXACTLY ONE emotion from this list ONLY:
   sadness, love, fear, pain, happiness, anger, despair
2. Never pick multiple emotions. Never say 'mixed'. Never say 'none'.
3. If unsure, default to 'neutral' (but neutral is NOT in options, so pick closest).

Respond with ONLY this JSON format - NOTHING ELSE:
{
  \"emotion\": \"ONE_WORD_FROM_LIST_ABOVE\",
  \"confidence\": 0.95
}

Sentence to classify: ", sentence, "\n\n",
    "JSON response:"
  )
}

# Process all sentences with progress

results <- data.frame(
  text = character(),
  emotion = character(),
  confidence = numeric(),
  stringsAsFactors = FALSE
)

cat("Processing", nrow(df), "sentences...\n")

for(i in 1:nrow(df)) {
  cat(i, "/", nrow(df), "\n")
  
  # Adjust column name
  sentence <- df[[1]][i]  # Uses first column - change if your sentences are in different column
  
  prompt <- emotion_prompt(sentence)
  raw_resp <- generate(model_name, prompt = prompt, output = "text")
  
  parsed <- tryCatch(fromJSON(raw_resp), error = function(e) NULL)
  emotion <- if(is.null(parsed$emotion)) "ERROR" else parsed$emotion
  conf <- if(is.null(parsed$confidence)) NA else parsed$confidence
  
  results <- rbind(results, data.frame(
    text = sentence,
    emotion = emotion,
    confidence = conf,
    stringsAsFactors = FALSE
  ))
}

# Save results as csv
write_csv(results, "results.csv")



## Results and evaluation

library(readr)
library(dplyr)

# Load files
manual <- read_csv("emotion_dataset.csv")    # text | sentiment
llm_results <- read_csv("results.csv")       # text | emotion | confidence

# Merge by text column
comparison <- manual %>%
  select(text, manual_emotion = sentiment) %>%
  left_join(llm_results %>% select(text, llm_emotion = emotion), by = "text") %>%
  filter(!is.na(llm_emotion))  # Only matched sentences

# Calculate accuracy
comparison <- comparison %>%
  mutate(
    correct = (manual_emotion == llm_emotion),
    match = ifelse(correct, "✓ CORRECT", "✗ WRONG")
  )

accuracy <- mean(comparison$correct, na.rm = TRUE) * 100

# Show results
cat("Total sentences compared:", nrow(comparison), "\n")
cat("Correct predictions:", sum(comparison$correct), "\n")
cat("Accuracy:", round(accuracy, 1), "%\n\n")

# mistakes
wrong <- comparison %>% filter(!correct)
print(wrong %>% select(text, manual_emotion, llm_emotion))

# Save comparison results
write_csv(comparison, "comparison_results.csv")
