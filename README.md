# OpenLLMs-Kursprojekt
This is a project for the master's programme course OpenLLMs by Dr. Jürgen Hermes of the University of Cologne

## Topic of the Project
- LLMs can be manipulated to accept factually wrong statements.
### Definition of the task
- We want to look at a specific OpenLLM and measure along a multitude of chats and statements how long it takes for the OpenLLM to accept a factually wrong statement. To do this we are going to replicate a study conducted by Xu et al. 2024 on persuasive multiturn chats with LLMs, and transfer it onto an OpenLLM of our choice.
### Choice of Open LLM
- We will be using the Apertus OpenLLM, because it has high standards, and we want to test if these standards are justifiable.
### Choice of dataset
- Framework based on Xu et al. 2024: Using the Farm dataset https://arxiv.org/abs/2312.09085
- Dataset: https://llms-believe-the-earth-is-flat.github.io
- Dataset contains factual questions paired with systematically generated persuasive misinformation and investigates 4 different persuasive strategies
- Therefore, it is representative for the chosen task and provides high complexity
