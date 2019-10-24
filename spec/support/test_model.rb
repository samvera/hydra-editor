class TestModel
  extend ActiveModel::Naming

  def self.reflect_on_association(property)
    case property
    when :creator
      OpenStruct.new(collection?: false)
    when :title
      OpenStruct.new(collection?: true)
    end
  end

  def self.multiple?(property)
    case property
    when :publisher
      false
    else
      true
    end
  end

  attr_accessor :title, :creator, :publisher
  def initialize(title: [], creator: nil, publisher: nil)
    @title = title
    @creator = creator
    @publisher = publisher
  end

  def attributes
    {
      title: title,
      creator: creator,
      publisher: publisher
    }.with_indifferent_access
  end

  def self.attribute_names
    %w[title creator publisher]
  end

  def new_record?
    true
  end

  def model_name
    self.class.model_name
  end

  def persisted?
    false
  end

  def to_key; end

  def errors
    {}
  end

  delegate :[], to: :attributes
end
