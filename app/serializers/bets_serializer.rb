# frozen_string_literal: true

class BetsSerializer < ActiveModel::Serializer::CollectionSerializer
  def serializable_hash(_adapter_options, _options, _adapter_instance)
    @object.group_by(&:team).map do |team, bets|
      {
        team: ActiveModelSerializers::SerializableResource.new(team).as_json,
        bets: bets.size
      }
    end
  end
end
