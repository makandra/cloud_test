
require 'thor/group'
module Cloudtest
  module Generators
    class Config < Thor::Group
      include Thor::Actions

      #argument :group, :type => :string
      #argument :name, :type => :string
      def self.source_root
        File.dirname(__FILE__) + "/configs"
      end

      def create_group
        if !Dir.exist?('config')
          empty_directory('config')
        end
      end
      def copy_config
        template("sample.cloudtest.config.yml", "config/cloudtest.config.yml")
      end

    end
  end
end
