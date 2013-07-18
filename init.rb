require "heroku/command/base"

# redis promotion commands
#
class Heroku::Command::Redis < Heroku::Command::Base

  REDIS_PROVIDERS = %w( OPENREDIS_URL REDISTOGO_URL REDISGREEN_URL )

  # redis
  #
  # lists the REDIS providers available for promotion
  #
  def index
    config = api.get_config_vars(app).body
    matches = config.keys & REDIS_PROVIDERS
    selected = REDIS_PROVIDERS.select do |key|
      config[key] == config['REDIS_URL']
    end

    matches.each do |match|
      display match
    end

    display selected
  end

  # redis:promote REDIS
  #
  # sets REDIS as your REDIS_URL
  #
  def promote
    unless redis = shift_argument
      error("Usage: heroku redis:promote REDIS\nMust specify REDIS to promote.")
    end
    validate_arguments!

    config = api.get_config_vars(app).body
    matches = config.keys & [redis || REDIS_PROVIDERS].flatten

    case matches.length
      when 0 then error "No redis add-on found"
      when 1 then
        display "Promoting #{matches.first}"
        promote_redis(config[matches.first])
      else error <<-ERROR
More than one redis add-on found, please specify one with:
heroku redis:promote REDIS
      ERROR
    end
  end

  private

  def promote_redis(url)
    api.put_config_vars(app, "REDIS_URL" => url)
  end

end