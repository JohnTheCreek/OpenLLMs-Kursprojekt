# OpenLLMs-Kursprojekt
This is a project for the master's programme course OpenLLMs by Dr. Jürgen Hermes of the University of Cologne

## Topic of the Project
- Sentiment analysis using an OpenLLM, specifically: recognition of particular emotions in sentences.

### Experiment and data
- Also, we wanted to create a small dataset, consisting of sentences or passages displaying a particular emotion. For every sentence, a category (emotion) is advised.
- We are writing a script for sentiment analysis.
- After having some problems with running LLMs locally, we decided to use Zephyr-7b with Google Colab.

### About the dataset
The sentences/passages were gathered from song lyrics by many different artists, all in English. The sentences, 72 in total, were then categorized regarding the emotion that it is about. Seven different emotions were categorized: Sadness, love, fear, pain, happiness, anger, despair.

Some of the sentences are very clear, and therefore, presumably easy to assign:
- "Somebody's gonna fall in love tonight" - love
- "To you I'm smiling, but really, I'm hurting" - pain
While others are more metaphorical or not as easy to recognize.

### Course of the project
During our project, we encountered some problems: The LLM would ignore our prompt given in the Python script and not give any output. It seems like this was due to using Google Colab. The script for that, using Zephyr-7b, is called OpenLLMs.ipynb
Despite it being a small LLM, we then tried using llama3.2:1b locally using Ollama. The script for this can be found under analysis_llama.R

The "results" folder contains both a csv file with the LLM results, and a csv file comparing these with our dataset (our manual classifications).
