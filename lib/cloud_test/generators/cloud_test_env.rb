require 'thor/group'
module CloudTest
  module Generators
    class  Support < Thor::Group
      include Thor::Actions
      def self.source_root
        File.dirname(__FILE__) + "/configs"
      end

      def create_group
        if !Dir.exist?('features/support')
          empty_directory('features/support')
        end
      end
      def copy_config
        template("sample.cloud_test.rb", "features/support/cloud_test.rb")
      end
    end
  end
end

