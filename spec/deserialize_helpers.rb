# frozen_string_literal: true

module DeserializeHelpers
  def deserialize_response(response)
    ActiveModelSerializers::Deserialization.jsonapi_parse(JSON.parse(response.body))
  end

  def deserialize_list(response)
    JSON.parse(response.body, symbolize_names: true)[:data].map do |raw_obj|
      raw_obj[:attributes].merge raw_obj.except(:attributes)
    end
  end
end
