# Author:: Bernd Ahlers (<bernd@torch.sh>)
# Copyright:: Copyright (c) 2014 Bernd Ahlers
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/knife'
require 'chef/knife/elb_base'

class Chef
  class Knife
    class ElbDelete < Knife
      include Chef::Knife::ElbBase

      banner 'knife elb delete ELB'

      def run
        $stdout.sync = true

        validate!

        response = connection.delete_load_balancer(@name_args.first)

        ui.output(Chef::JSONCompat.from_json(response.data[:body].to_json))
      end

      private

      def validate!
        super

        unless @name_args.size == 1
          ui.error('Please specify the ELB ID')
          exit 1
        end
      end
    end
  end
end