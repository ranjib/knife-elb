
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
    class ElbInstanceDelete < Knife
      
      include  Knife::ElbBase

      banner "knife elb instance delete ELB INSTANCE"

      def run
        if @name_args.size != 2
          ui.error('Please provide ELB ID and Istance ID')
          exit(1)
        end
        elb_id = @name_args[0]
        instance = @name_args[1]
        elbs = connection.load_balancers.select{|elb| elb.id == elb_id}
        if elbs.empty?
          ui.error("No ELB with id #{elb_id} found")
          exit(1)
        end  

        elbs.first.deregister_instances(instance)
        ui.info("Instance removed")
      end  
    end
  end
end

