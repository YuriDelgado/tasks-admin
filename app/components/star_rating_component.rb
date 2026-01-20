# frozen_string_literal: true

class StarRatingComponent < ViewComponent::Base
  def initialize(
    name:,
    value: 0,
    max: 5,
    id_prefix: nil,
    readonly: false
  )
    @name       = name
    @value      = value.to_i
    @max        = max
    @id_prefix  = id_prefix || name.parameterize(separator: "_")
  end
end
