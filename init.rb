require "heroku/command/base"

# redis promotion commands
#
class Heroku::Command::Redis < Heroku::Command::Base

  REDIS_PROVIDERS = %w( OPENREDIS_URL REDISTOGO_URL REDISGREEN_URL REDISCLOUD_URL )

  # redis
  #
  # lists the REDIS providers available for promotion
  #
  def index
    config = api.get_config_vars(app).body
    matches = config.keys & REDIS_PROVIDERS
    current = config['REDIS_URL']

    selected = REDIS_PROVIDERS.select do |key|
      config[key] == current && !current.nil?
    end

    if selected.empty?
      display "No REDIS instance currently set to REDIS_URL"
    else
      display "Currently using #{selected.first}\n"
    end

    display
    display 'Available REDIS providers'
    matches.each do |match|
      display " #{match}"
    end
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
        display "Promoting #{matches.first}..."
        promote_redis(config[matches.first])
        display "Promoted! Heroku will restart the app."
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