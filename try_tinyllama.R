# install.packages("ollamar")

library(ollamar)
library(readr)
library(jsonlite)

# Load CSV and check if works
df <- read_csv("emotion_sentences.csv")
class(df)
test_connection()  # test connection to Ollama server

# download a model
pull("llama3.2:1b")

# test: generate a response/text based on a prompt; returns an httr2 response by default
resp <- generate("llama3.2:1b", "tell me a 5-word story")
resp

#' interpret httr2 response object
#' <httr2_response>
#' POST http://127.0.0.1:11434/api/generate  # endpoint
#' Status: 200 OK  # if successful, status code should be 200 OK
#' Content-Type: application/json
#' Body: In memory (414 bytes)

# get just the text from the response object
resp_process(resp, "text")

# get the text as a tibble dataframe
resp_process(resp, "df")

# OR specify output type when calling the function initially
txt <- generate("llama3.2:1b", "tell me a 5-word story", output = "text")

# list available models (models you've pulled/downloaded)
list_models()

------

# Sentiment analysis with llama3.2:1b

# 1) Load YOUR file
df <- read_csv("emotion_sentences.csv")

# Use SMALL model (llama3.2:1b is fast + reliable)
model_name <- "llama3.2:1b"
# pull(model_name)  # if not pulled before

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
  
  # Adjust column name below if needed (check: names(df))
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


