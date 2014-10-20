
#
# Author:: Ranjib Dey (<dey.ranjib@gmail.com>)
# Copyright:: Copyright (c) 2013 Ranjib Dey.
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
#

require 'chef/knife'
require 'chef/knife/elb_base'

class Chef
  class Knife
    class ElbList < Knife
      
      include  Knife::ElbBase

      banner "knife elb list"

      def run
        validate!

        elb_list = [
          ui.color('ELB Id', :bold),
          ui.color('DNS', :bold),
          ui.color('Total instances', :bold),
          ui.color('Active instances', :bold),
          ui.color('Created At', :bold),
          ui.color('Zones', :bold)
        ].flatten.compact
        
        output_column_count = elb_list.length
        
        connection.load_balancers.each do |elb|

          total_instances = elb.instances.size
          instances_in_service = elb.instances_in_service.size

          elb_list << elb.id.to_s
          elb_list << elb.dns_name

          elb_list << if total_instances == 0
                        ui.color(total_instances.to_s, :red)
                      else
                        ui.color(total_instances.to_s, :green)
                      end
          elb_list << if (instances_in_service  != total_instances)
                        ui.color(instances_in_service.to_s, :red)
                      else
                        ui.color(instances_in_service.to_s, :green)
                      end
          elb_list << elb.created_at.to_s
          elb_list << elb.availability_zones.join(',')
        end
        puts ui.list(elb_list, :uneven_columns_across, output_column_count)
      end  
    end
  end
end

