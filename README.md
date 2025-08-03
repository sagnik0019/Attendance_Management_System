
# Attendance Management System
=====================================

A Ruby on Rails application for managing student attendance records with features for both teachers and students. Teachers can record and edit attendance, while students can view their attendance history.

## Project Setup Instructions
-----------------------------

### Prerequisites

* Ruby 3.4.5 installed (follow the installation guide at [GoRails Tutorial](https://gorails.com/setup/ubuntu/22.04))
* PostgreSQL database installed and running

### Step 1: Clone the Repository

 Clone the repository using the following command:
```bash
git clone https://github.com/your-username/attendance-management-system.git
```Here is a generated README file in markdown format for your Ruby on Rails project:
Replace `your-username` with your actual GitHub username.

### Step 2: Install Dependencies

 Run the following command to install the required dependencies:
```bash
bundle install
```
This command will install all the gems specified in the `Gemfile`.

### Step 3: Database Setup

 Run the following command to create the database and run the migrations:
```bash
rails db:create db:migrate
```
This command will create the PostgreSQL database and run the migrations to set up the schema.

### Step 4: Seed the Database

 Run the following command to seed the database with initial data:
```bash
rails db:seed
```
This command will populate the database with the necessary data.

## Running the Project
-----------------------

### Step 1: Start the Rails Server

 Run the following command to start the Rails server:
```bash
rails server
```
This command will start the Rails server in development mode.

### Step 2: Access the Application

 Open a web browser and navigate to `http://localhost:3000` to access the application.
