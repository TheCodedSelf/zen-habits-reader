# README #

Zen Breath is a convenient and easy to use portal to the popular blog Zen Habits. I built it for my own benefit and put it on the iOS App Store.

The application uses Core Data to store all posts on the blog and some metadata such as whether or not you have read the post. The app fetches all posts from the website using an HTML parsing algorithm that I wrote. Each day it performs a background fetch to check if new posts have been released and sends a notification to the user if a new post was found.