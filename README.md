# Simplesite

Simplesite is a boilerplate nodejs project I created after going thru the same setup over and over again.

Start by creating adding a file inside the `routes` directory, look for `pages.coffee` for an example.

## Requirements

If you want to restart your app automatically after every change, install `supervisor` like this:

    npm install -g supervisor


You can then start your app on your development machine like this:

    foreman start -f Procfile.dev

