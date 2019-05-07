# frozen_string_literal: true

class SaveApplicationRecordObject
  include Interactor

  def call
    if context.object_to_save.save
      nil
    else
      context.fail!
    end
  end
end
