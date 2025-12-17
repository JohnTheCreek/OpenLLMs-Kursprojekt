# OpenLLMs-Kursprojekt
This is a project for the master's programme course OpenLLMs by Dr. Jürgen Hermes of the University of Cologne

## Topic of the Project
- Sentiment analysis using an OpenLLM, specifically: recognition of particular emotions in sentences.

(Originally, we wanted to to replicate a study conducted by Xu et al. 2024 on persuasive multiturn chats with LLMs, and transfer it onto a specific OpenLLM (Apertus) and measure along a multitude of chats and statements how long it takes for the OpenLLM to accept a factually wrong statement. After having tested the approach described above, we encountered several difficulties (dataset and scope of experiment too big, problems with running the model "swiss-ai/Apertus-70B-Instruct-2509")).

### Experiment and data
Hence, we are opting for a sentiment analysis experiment wit another LLM:
- We decided on a new LLM: tinyllama
- Also, we wanted to create a small dataset, consisting of sentences or passages displaying a particular emotion. For every sentence, a category (emotion) is advised.
- We are writing a script for sentiment analysis.

### About the dataset
The sentences/passages were gathered from song lyrics by many different artists, all in English. The sentences, 71 in total, were then categorized regarding the emotion that it is about. The distribution looks like this:
1 sadness      24
2 love         15
3 fear          8
4 pain          8
5 happiness     7
6 anger         5
7 despair       4

Some of them are very clear, and therefore, presumably easy to assign:
- "Somebody's gonna fall in love tonight" - love
- "To you I'm smiling, but really, I'm hurting" - pain
While others are more metaphorical or not as easy to recognize. 
