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
    class ElbListenerDelete < Knife
      include Chef::Knife::ElbBase

      banner 'knife elb listener delete ELB PORT'

      def run
        $stdout.sync = true

        validate!

        response = connection.delete_load_balancer_listeners(@name_args.shift, @name_args)

        ui.output(Chef::JSONCompat.from_json(response.data[:body].to_json))
      end

      private

      def validate!
        super

        if @name_args.size < 2
          ui.error('Please specify the ELB ID and the listener PORT to remove')
          exit 1
        end
      end
    end
  end
end