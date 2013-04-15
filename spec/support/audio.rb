# A class just for testing
class Audio < ActiveFedora::Base
  include Hydra::ModelMixins::RightsMetadata
  
  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata "rightsMetadata", type: Hydra::Datastream::RightsMetadata

  # Tufts specific needed metadata streams
  has_metadata "descMetadata", :type => ActiveFedora::QualifiedDublinCoreDatastream

  validates_presence_of :title#, :creator, :description
  
  delegate_to "descMetadata", [:title, :creator, :description, :subject]

  def terms_for_editing
    [:title, :creator, :description, :subject]
  end
end
