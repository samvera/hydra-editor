# A class just for testing
class Audio < ActiveFedora::Base
  # include Hydra::AccessControls::Permissions

  validates_presence_of :title

  # the isPartOf attribute should not get set, because it's not listed in "terms_for_editing"
  property :title, predicate: ::RDF::Vocab::DC11.title
  property :creator, predicate: ::RDF::Vocab::DC11.creator
  property :description, predicate: ::RDF::Vocab::DC11.description
  property :subject, predicate: ::RDF::Vocab::DC11.subject
  property :isPartOf, predicate: ::RDF::Vocab::DC.isPartOf
end
