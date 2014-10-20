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
    class ElbHealthCheck < Knife
      include Chef::Knife::ElbBase

      PROTOCOLS = %w(HTTP HTTPS TCP SSL)

      banner 'knife health check ELB (options)'

      option :healthy_threshold,
             :long => '--healthy-threshold INT',
             :description => 'Number of consecutive health probe successes before moving instance to healthy (default 2)',
             :default => 2,
             :proc => Proc.new { |i| i.to_i }

      option :unhealthy_threshold,
             :long => '--unhealthy-threshold INT',
             :description => 'Number of consecutive health probe failures before moving instance to unhealthy (default 2)',
             :default => 2,
             :proc => Proc.new { |i| i.to_i }

      option :check_interval,
             :long => '--check-interval SECONDS',
             :description => 'Health check interval in seconds (default 30)',
             :default => 30,
             :proc => Proc.new { |i| i.to_i }

      option :check_timeout,
             :long => '--check-timeout SECONDS',
             :description => 'Health check timeout in seconds (default 10)',
             :default => 10,
             :proc => Proc.new { |i| i.to_i }

      option :check_target,
             :long => '--check-target VALUE',
             :description => 'Health check target specification. (i.e. HTTP:8080/ping, TCP:5555)',
             :proc => Proc.new { |i| i.to_s }

      def run
        validate!

        response = connection.configure_health_check(@name_args.first, build_health_check(config))

        ui.output(Chef::JSONCompat.from_json(response.data[:body].to_json))
      end

      private

      def validate!
        super

        unless @name_args.size == 1
          ui.error('Please specify the ELB ID')
          exit 1
        end

        if config[:check_target].to_s.empty?
          ui.error('Please specify the check target. (i.e. HTTP:8080/ping, TCP:5555')
          exit 1
        end

        validate_check_target(config[:check_target])
      end

      def validate_check_target(target)
        error = false
        proto, port_and_path = target.to_s.split(':', 2)
        port = port_and_path.to_s.split('/', 2).first

        unless PROTOCOLS.include?(proto.to_s.upcase)
          ui.error("Invalid protocol for check target: #{proto.to_s.inspect} (available: #{PROTOCOLS.join(' ')})")
          error = true
        end

        unless port =~ /^\d+$/
          ui.error("Invalid port number for check target: #{port.to_s.inspect} (use a number)")
          error = true
        end

        exit 1 if error
      end

      def build_health_check(config)
        # See: http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_HealthCheck.html
        {
            'HealthyThreshold' => config[:healthy_threshold],
            'UnhealthyThreshold' => config[:unhealthy_threshold],
            'Interval' => config[:check_interval],
            'Target' => config[:check_target],
            'Timeout' => config[:check_timeout]
        }
      end
    end
  end
end
