class FormStub
  include ActiveModel::Model

  attr_accessor :name, :color

  def self.all
    []
  end
end
