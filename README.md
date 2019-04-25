# DemoProject
This project simply demonstrates the Swift code design with MVVM, Core Data, and Unit tests for fulfilling the Requirements. Please note it's not a project to demo the UI design so please bare with me for the UI details.

## Requirements:
1. Film search (using this API endpoint https://api.themoviedb.org/3/search/movie?api_key=4cb1eeab94f45affe2536f2c684a5c9e&query=<search_query> (GET))
2. The user should be able to see details of the film (endpoint https://api.themoviedb.org/3/movie/<id>?api_key=4cb1eeab94f45affe2536f2c684a5c9e  (GET))
3. The user should be able to favorite and unfavorite a movie
4. The user should be able to see a list of favorite movies

## Setup
Please run `pod install` before opening the .xcworkspace file. It mainly installs Nimble and Quick which are needed for unit tests.
After opening the workspace, you could choose to run for demo or unit tests.
For running, please search the movies and favor the movie in the detail screen. After having any favorite movie it will show in the main screen.
