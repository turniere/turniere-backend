# frozen_string_literal: true

module DeserializeHelpers
  def deserialize_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
