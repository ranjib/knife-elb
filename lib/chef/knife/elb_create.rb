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
require 'chef/knife/elb_listener_base'

class Chef
  class Knife
    class ElbCreate < Knife
      include Chef::Knife::ElbBase
      include Chef::Knife::ElbListenerBase

      banner 'knife elb create ELB (options)'

      option :availability_zones,
             :long => '--availability-zones eu-west-1a[,eu-west-1b,eu-west-1c]',
             :description => 'The ELB availability zones (default eu-west-1a)',
             :default => ['eu-west-1a'],
             :proc => Proc.new { |i| i.to_s.split(',') }

      def run
        $stdout.sync = true

        validate!

        response = connection.create_load_balancer(
            config[:availability_zones],
            @name_args.first,
            build_listeners(config)
        )

        ui.output(Chef::JSONCompat.from_json(response.data[:body].to_json))
      end

      private

      def validate!
        super

        unless @name_args.size == 1
          ui.error('Please specify the ELB ID')
          exit 1
        end

        if config[:availability_zones].empty?
          ui.error("You have not provided a valid availability zone value. (-Z parameter)")
          exit 1
        end
      end
    end
  end
end