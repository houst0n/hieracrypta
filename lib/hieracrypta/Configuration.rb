require 'json'

module Hieracrypta
  class Configuration
    def initialize(config_file=File.expand_path("config.json", File.dirname(__FILE__)))
      json_config = File.read(config_file)
      @config=JSON.parse(json_config)
    end
    
    def get(config_item)
      path_items=config_item.split('/')
      result=@config
      path_items.each { | item |
        result=result[item]
        if result.nil?
          raise NoSuchConfiguration.new(config_item)
        end
      }
      result
    end
    
    def get_admin_keyring_location
      admin_keyring_location=@config['admin_keyring_location']
      if !(admin_keyring_location.start_with?('/'))
        File.expand_path(admin_keyring_location, File.dirname(__FILE__))
      end
    end
  end
  CONFIGURATION=Configuration.new()
end
