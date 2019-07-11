require 'thor/group'
module CloudTest
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
        template("sample.cloud_test.yml", "config/cloud_test.yml")
        template("sample.cloud_test.rb", "feautures/support/sample.cloud_test.rb")
      end
    end
  end
end
