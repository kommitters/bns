module Exceptions
  module Discord
    def self.validate_response(response)
      case response["code"]
      when 50_027
        raise Exceptions::Discord::InvalidWebook, response["message"]
      else
        response
      end
    end
  end

  module Notion
  end
end
