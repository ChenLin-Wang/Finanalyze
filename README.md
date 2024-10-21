# Finanalyze

**Finanalyze** is an advanced consumption tracking and analysis tool that leverages AI to enhance users' financial management experience. The software allows users to record, analyze, and share their daily purchases with minimal effort. Its standout feature is the integration of AI, which helps automate the input of purchase details, categorize expenses, and even analyze spending patterns. Whether you're manually entering data or letting AI handle receipt scanning and categorization, Finanalyze provides powerful insights into your spending habits. 

This project is part of the course **CpE 314 - Software Designing**, where the goal is to build a modern, functional system combining state-of-the-art technologies such as AI and web development frameworks.

[See our website here](http://finanalyze.inspiral.site:3000)

## Features

### 1. Account System

- Users must create an account with an email and password.
- *Optional*: Users can add basic information and contact numbers.

### 2. Data Record

- Manually input item name, price, and quantity or (Maybe) use AI to analyze photos of receipts and automatically extract item details such as name, type, and brand.
- Automatically record the purchase location, date, and time.
- AI-powered classification of items into categories.
- Type manually record the store name and mark it on a map based on the consumption location. Or (Maybe) AI can mark it automatically, depends on the location you make consumption.

### 3. Analysis and Training

- Collect statistics on consumption for each category daily, weekly, monthly, and yearly, presented as charts and diagrams.
- Ask questions to the AI bot, which will provide answers based on the user's and their friends' consumption data.

### 4. Sharing

- Users can add friends and view their consumption and store data.
- Users can choose to make specific records public or private.



## Develop Plan

Project time limit - **Nov, 3, 2024**

Start at **Sep 16, 2024**

**48 Days in total!**

| Activity Code | Description/Task Sets               | Estimated Time(Day)      | Predecessors                | Remaining Days | Progress   |
| ------------- | ----------------------------------- | ------------------------ | --------------------------- | -------------- | ---------- |
| 1             | Gather Datas                        | 31 **(Sep 16 - Oct 17)** | Asynchronous Task           | -              | -          |
| 2             | Find References & Functional Design | 3 **(Sep 16 - Sep 19)**  | -                           | 45             | ✅ (Sep 19) |
| 3             | UI Design                           | 7 **(Sep 19 - Sep 26)**  | 2                           | 38             | ✅ (Sep 29) |
| 4             | Implement (Coding!)                 | 21 **(Sep 26 - Oct 17)** | 2, 3                        | 17             | ✅ (Oct 21) |
| 5             | Test and Debug                      | 3 **(Oct 17 - Oct 20)**  | 2, 3, 4                     | 14             | -          |
| 6             | Finish The Project Plan             | 11 **(Oct 20 - Oct 31)** | 1, 2, 3, 4, 5. Can be Asyn. | 3              | -          |



## UI Design

Not yet



## Tech Stack

- **Frontend**: Nuxt.js + Vue.js + TypeScript
- **Backend**: Vapor + Swift
- **Database**: PostgreSQL
- **AI Integration**: Google Vision AI
- **Hosting**:
  - **Domain Name**: GoDaddy
  - **Cloud Server**: Google VPS (Ubuntu 22.04.5 LTS)



## Project Goals

This project is developed for **CpE 314 - Software Designing** course. The goal is to create a functional system that integrates modern web technologies with AI for smart consumption analysis and record.



## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/finanalyze.git
   ```

2. Install dependencies:

   ```bash
   cd finanalyze
   npm install
   ```

3. Configure PostgreSQL connection settings in `.env`.

4. Run the development server:

   ```bash
   npm run dev
   ```

## Contribution

Feel free to contribute to this project by opening an issue or submitting a pull request. All contributions are welcome!