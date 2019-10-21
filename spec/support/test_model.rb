class TestModel
  def self.reflect_on_association(property)
    if property == :creator
      OpenStruct.new(collection?: false)
    else
      OpenStruct.new(collection?: true)
    end
  end

  def self.model_name
    to_s
  end

  attr_reader :title, :creator
  def initialize(title: [], creator: nil)
    @title = title
    @creator = creator
  end

  def attributes
    {
      title: title,
      creator: creator
    }.with_indifferent_access
  end
end
