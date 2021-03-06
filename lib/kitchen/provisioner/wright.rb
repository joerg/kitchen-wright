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

      default_config :wrightfile, 'wright.rb'
      default_config :install_method, 'bundler_local'
      default_config :log_level, 'default'
      default_config :dry_run, 'false'

      def install_command
        wright_shell_code_from_file([], "install_command")
      end

      def init_command
        # Create folder for upload, otherwise /tmp/kitchen will be a file
        return "mkdir -p #{config[:root_path]}"
      end

      def create_sandbox
        super
        debug("Creating local sandbox in #{sandbox_path}")
        # Fix config[:attributes] if it does not exist
        config[:attributes] = {} unless config.key?(:attributes)

        yield if block_given?

        prepare_wrightfile
        prepare_gemfile unless File.exist?('Gemfile')
        info('Finished Preparing files for transfer')
      end

      def cleanup_sandbox
        return if sandbox_path.nil?
        debug("Cleaning up local sandbox in #{sandbox_path}")
        FileUtils.rmtree(sandbox_path)
      end

      def prepare_command
        method = install_method
        if %w(bundler_local bundler_global).include? method
          wright_shell_code_from_file(
            ["WORKDIR=#{config[:root_path]}", "OPTIONS=#{bundler_options}"],
            'prepare_command_bundler'
          )
        else
          raise "Install method #{method} not supported."
        end
      end

      def run_command
        wright_shell_code_from_file(
          ["WORKDIR=#{config[:root_path]}", "WRIGHTFILE=#{wrightfile}", "OPTIONS=#{wright_options}"],
          "run_command_#{install_method}"
        )
      end

      protected

      def prepare_wrightfile
        info('Preparing wrightfile')
        debug("Copying all wrightfiles to #{sandbox_path}")
        (Dir.glob(File.join("**"))-prepare_excludes).each do |t|
          FileUtils.cp_r(t, sandbox_path)
        end
      end

      def wrightfile
        config[:attributes][:wrightfile] || config[:wrightfile]
      end

      def install_method
        config[:attributes][:install_method] || config[:install_method]
      end

      def wright_options
        opts = []
        dry = config[:attributes][:dry_run] || config[:dry_run]
        level = config[:attributes][:log_level] || config[:log_level]

        opts << '--dry-run' if dry == 'true'
        opts << '--verbose' if level == 'verbose'
        opts << '--quiet' if level == 'quiet'

        opts.join(' ')
      end

      def bundler_options
        opts = []
        #opts << '--without development'
        opts << '--path .bundle' if install_method == 'bundler_local'

        '"' + opts.join(' ') + '"'
      end

      def prepare_gemfile
        gemfile_content = <<-GEMFILE
        source 'https://rubygems.org'
        gem 'wright'
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
        %w(.git .bundle test
           .kitchen.yml .kitchen.local.yml
           README.md README.rdoc)
      end
    end
  end
end
