# -*- encoding: utf-8 -*-
#
# Author:: Jörg Herzinger (<joerg.herzinger@oiml.at>)
#
# Copyright (C) 2015 Jörg Herzinger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'json'
require 'kitchen/provisioner/base'

module Kitchen
  module Provisioner
    #
    # Wright provisioner.
    #
    class Wright < Base
      attr_accessor :tmp_dir

      default_config :wrightfile do |provisioner|
        'wright.rb' if File.exist?('wright.rb') or
        raise "No wright file found or specified!  Please either set a playbook in your .kitchen.yml config, or create a default wrapper playbook for your role in test/integration/playbooks/default.yml or test/integration/default.yml"
      end

      def install_command
        method = config[:install_method]
        unless %w(gems).include? method
          raise "Install method #{method} not supported."
        end
        wright_shell_code_from_file([], "install_command_#{method}")
      end

      def init_command
        return "mkdir -p #{config[:root_path]}" # Make folder for upload, otherwise /tmp/kitchen will be a file
      end

      def create_sandbox
        super
        debug("Creating local sandbox in #{sandbox_path}")

        yield if block_given?

        prepare_wrightfile
        #prepare_gemfile if config[:install_method] == 'bundler'
        info('Finished Preparing files for transfer')
      end

      def cleanup_sandbox
        return if sandbox_path.nil?
        debug("Cleaning up local sandbox in #{sandbox_path}")
        FileUtils.rmtree(sandbox_path)
      end

      def prepare_command
        method = config[:install_method]
        unless %w(gems).include? method
          raise "Install method #{method} not supported."
        end
        wright_shell_code_from_file([], "prepare_command_#{method}")
      end

      def run_command
        wright_shell_code_from_file(
          ["WORKDIR=#{config[:root_path]}", "WRIGHTFILE=#{wrightfile}"],
          'run_command'
        )
      end

      protected

      def prepare_wrightfile
        info('Preparing wrightfile')
        debug("Copying wrightfile from #{wrightfile} to #{sandbox_path}")
        (Dir.glob(File.join("**"))-prepare_excludes).each do |t|
          FileUtils.cp_r(t, sandbox_path)
        end
      end

      def wrightfile
        config[:wrightfile]
      end

      # For install with bundler. Not used yet.
      def prepare_gemfile
        gemfile_content = <<-GEMFILE
        source 'https://rubygems.org'
        gem 'wright',        '~> 0.3.0'
        GEMFILE
        File.write(sandbox_path + '/Gemfile', gemfile_content)
      end

      # This is a shameful copy from test-kitchen.
      # Without the copy, the path won't be correct.
      def wright_shell_code_from_file(vars, file)
        src_file = File.join(
          File.dirname(__FILE__),
          %w[.. .. .. support],
          file + ".sh"
        )

        wrap_shell_code([vars, "", IO.read(src_file)].join("\n"))
      end

      def prepare_excludes
        %w(.git .bundle test Gemfile Gemfile.lock
           .kitchen.yml .kitchen.local.yml README.md
           README.rdoc)
      end
    end
  end
end
