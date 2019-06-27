
require 'thor/group'
module Cloudtest
  module Generators
    class Config < Thor::Group
      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__) + "/configs"
      end

      def create_group
        if !Dir.exist?('config')
          empty_directory('config')
        end
      end
      def copy_config
        template("sample.cloud_test.config.yml", "config/cloud_test.yml")
      end

    end
  end
end
