# frozen_string_literal: true

class SaveApplicationRecordObject
  include Interactor

  def call
    Array(context.object_to_save).flatten.each do |object|
      context.fail! unless object.save
    end
  end
end
