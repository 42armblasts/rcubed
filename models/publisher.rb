class Publisher < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  def as_json(options)
    super(only: [:id, :name, :hostname])
  end
end