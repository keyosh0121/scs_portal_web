class ApplicationRecord < ActiveRecord::Base
  require 'tod/core_extensions'
  require 'tod'
  self.abstract_class = true
end
