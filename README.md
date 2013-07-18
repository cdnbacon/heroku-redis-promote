# heroku-redis-promote

Updates the `REDIS_URL` environment variable to point to a specific REDIS provider URL.

## Installation

    $ heroku plugins:install https://github.com/busbud/heroku-redis-promote

## Usage

    $ heroku redis
    No REDIS instance currently set to REDIS_URL

    Available REDIS providers
     REDISTOGO_URL

    $ heroku redis:promote REDISTOGO_URL
    Promoting REDISTOGO_URL...
    Promoted! Heroku will restart the app.

## License

MIT
