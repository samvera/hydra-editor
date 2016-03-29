# A class just for testing
class Audio < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  # Tufts specific needed metadata streams
  contains 'descMetadata', class_name: 'ActiveFedora::QualifiedDublinCoreDatastream'

  validates_presence_of :title

  # the isPartOf attribute should not get set, because it's not listed in "terms_for_editing"
  property :title, delegate_to: 'descMetadata'
  property :creator, delegate_to: 'descMetadata'
  property :description, delegate_to: 'descMetadata'
  property :subject, delegate_to: 'descMetadata'
  property :isPartOf, delegate_to: 'descMetadata'
end
