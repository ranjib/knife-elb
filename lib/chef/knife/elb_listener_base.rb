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

class Chef
  class Knife
    module ElbListenerBase
      def self.included(includer)
        includer.class_eval do
          option :listener_proto,
                 :long => '--listener-protocol HTTP',
                 :description => 'Listener protocol (available: HTTP, HTTPS, TCP, SSL) (default HTTP)',
                 :default => 'HTTP',
                 :proc => Proc.new { |i| i.to_s.upcase }

          option :listener_instance_proto,
                 :long => '--listener-instance-protocol HTTP',
                 :description => 'Instance connection protocol (available: HTTP, HTTPS, TCP, SSL) (default HTTP)',
                 :default => 'HTTP',
                 :proc => Proc.new { |i| i.to_s.upcase }

          option :listener_lb_port,
                 :long => '--listener-lb-port 80',
                 :description => 'Listener load balancer port (default 80)',
                 :default => 80,
                 :proc => Proc.new { |i| i.to_i }

          option :listener_instance_port,
                 :long => '--listener-instance-port 80',
                 :description => 'Instance port to forward traffic to (default 80)',
                 :default => 80,
                 :proc => Proc.new { |i| i.to_i }

          option :ssl_certificate_id,
                 :long => '--ssl-certificate-id SSL-ID',
                 :description => 'ARN of the server SSL certificate',
                 :proc => Proc.new { |i| i.to_s }

          def build_listeners(config)
            [
                {
                    'Protocol' => config[:listener_proto],
                    'LoadBalancerPort' => config[:listener_lb_port],
                    'InstancePort' => config[:listener_instance_port],
                    'InstanceProtocol' => config[:listener_instance_proto],
                    'SSLCertificateId' => config[:ssl_certificate_id]
                }
            ]
          end
        end

      end
    end
  end
end
