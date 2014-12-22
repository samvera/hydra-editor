require_relative 'audio'
class AudioForm < HydraEditor.Presenter(::Audio)
  self.terms = [:title, :creator, :description, :subject, :isPartOf]
  include HydraEditor::Form
  self.required_fields = [:title, :creator]
end
