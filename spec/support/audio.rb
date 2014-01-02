# A class just for testing
class Audio < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  
  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata "rightsMetadata", type: Hydra::Datastream::RightsMetadata

  # Tufts specific needed metadata streams
  has_metadata "descMetadata", type: ActiveFedora::QualifiedDublinCoreDatastream

  validates_presence_of :title

  # the isPartOf attribute should not get set, because it's not listed in "terms_for_editing"
  has_attributes :title, :creator, :description, :subject, :isPartOf, datastream: "descMetadata", multiple: true
  

  def terms_for_editing
    [:title, :creator, :description, :subject]
  end
end
