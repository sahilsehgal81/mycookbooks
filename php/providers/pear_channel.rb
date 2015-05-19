require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :discover do
  unless exists?
    Chef::Log.info("Discovering pear channel #{@new_resource}")
    execute "pear channel-discover #{@new_resource.channel_name}" do
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

action :add do
  unless exists?
    Chef::Log.info("Adding pear channel #{@new_resource} from #{@new_resource.channel_xml}")
    execute "pear channel-add #{@new_resource.channel_xml}" do
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

action :update do
  if exists?
    update_needed = false
    begin
      updated_needed = true if shell_out("pear search -c #{@new_resource.channel_name} NNNNNN").stdout =~ /channel-update/
    rescue Chef::Exceptions::CommandTimeout


Chef::Log.info("Timed out checking if channel-update needed...forcing update of pear channel #{@new_resource}")
      update_needed = true
    end
    if update_needed
      Chef::Log.info("Updating pear channel #{@new_resource}")
      shell_out!("pear channel-update #{@new_resource.channel_name}")
      new_resource.updated_by_last_action(true)
    end
  end
end

action :remove do
  if exists?
    Chef::Log.info("Deleting pear channel #{@new_resource}")
    execute "pear channel-delete #{@new_resource.channel_name}" do
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PhpPearChannel.new(@new_resource.name)
  @current_resource.channel_name(@new_resource.channel_name)
  @current_resource
end

private
def exists?
  begin
    shell_out!("pear channel-info #{@current_resource.channel_name}")
    true
  rescue Chef::Exceptions::ShellCommandFailed
    false
  end
end

