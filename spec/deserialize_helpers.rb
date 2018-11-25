# frozen_string_literal: true

module DeserializeHelpers
  def deserialize_response(response)
    ActiveModelSerializers::Deserialization.jsonapi_parse(JSON.parse(response.body))
  end
end
