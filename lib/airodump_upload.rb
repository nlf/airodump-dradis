# AirodumpUpload

require 'airodump_upload/filters'
require 'airodump_upload/meta'

module AirodumpUpload
  class Configuration < Core::Configurator
    configure :namespace => 'airodump_upload'
    setting :category, :default => 'Airodump-ng output'
    setting :author, :default => 'Airodump-ng plugin'
    # setting :my_setting, :default => 'Something'
    # setting :another, :default => 'Something Else'
  end
end

# This includes the import plugin module in the dradis import plugin repository
module Plugins
  module Upload 
    include AirodumpUpload
  end
end
