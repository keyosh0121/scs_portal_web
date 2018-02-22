class ApplicationRecord < ActiveRecord::Base
  require 'tod'
  require 'tod/core_extensions'
  self.abstract_class = true
end
