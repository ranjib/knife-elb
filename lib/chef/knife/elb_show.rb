
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
require 'chef/knife/ec2_base'
require 'json'

class Chef
  class Knife
    class ElbShow < Knife
      
      include  Knife::ElbBase

      banner "knife elb show ELB"

      def run
        unless @name_args.size ==1 
          ui.error('Please specify the ELB ID')
          exit 1
        end
        elbs = connection.load_balancers.select{|elb| elb.id == @name_args.first}
        if elbs.empty?
          ui.error("No load balancer with id  #{@name_args.first} found")
          exit 1
        end
        ui.output(JSON.parse(elbs.first.to_json))
      end  
    end
  end
end

