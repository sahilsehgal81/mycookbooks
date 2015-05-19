#
# Cookbook Name:: nginx
# Recipe:: default
# Author:: Jagtaveer Singh
#


source_url = "http://nginx.org/download/nginx-#{node['nginx']['version']}.tar.gz"

src_path = "#{node['nginx']['compile_dir']}" + "/nginx-#{node['nginx']['version']}.tar.gz"

isupgrade = false
#Upgrade check
if File.exist?('/etc/init.d/nginx') 
  current_version = `#{node['nginx']['prefix']}/sbin/nginx -v | grep -Po "(\d+\.\d+\.\d+)"` 
  if "#{current_version}" >= "#{node['nginx']['version']}" 
    exit
  end

  #We are going to upgrade backup and then restore the config
  
  FileUtils.cp_r("#{node['nginx']['conf']}","#{node['nginx']['conf_backup']}")
    isupgrade = true

end
remote_file source_url do
        source source_url
        path src_path
        backup false
end

execute "unarchive_source" do
        cwd "#{node['nginx']['compile_dir']}"
         command "tar zxf nginx-#{node['nginx']['version']}.tar.gz"
end

execute "install_nginx" do
        cwd "#{node['nginx']['compile_dir']}" + "/nginx-#{node['nginx']['version']}"
     command <<-EOF
        ./configure #{node['nginx']['config_params']} --user=#{node['nginx']['nginx_user']} --group=#{node['nginx']['nginx_group']}
        make
        make install
EOF
end

group node['nginx']['nginx_group'] do
  action :create
end

user node['nginx']['nginx_user'] do
  gid node['nginx']['nginx_group']
  shell '/bin/nologin'
  system true
  action :create
end

template node['nginx']['nginx_prefix'] + '/conf/nginx.conf' do
  source 'nginx.conf.erb'
  mode 0644
  variables({
    'user' => node['nginx']['nginx_user'],
    'prefix' => node['nginx']['prefix'],
    'pid' => node['nginx']['pid_path'],
    'doc_root' => node['nginx']['doc_root'],
    'http_port' => node['nginx']['http_port']
  })
end

template '/etc/init.d/nginx' do
  source 'nginx.erb'
  mode 0755
  variables({
    'prefix' => node['nginx']['prefix'],
    'lock_file' => node['nginx']['lock_file']
  })
end

#Setup directory structure

directory node['nginx']['doc_root'] do
  owner node['nginx']['nginx_user']
  group node['nginx']['nginx_group']
  action :create
end

directory node['nginx']['prefix'] + '/conf/' + node['nginx']['vhostconf_dir'] do
action :create
end
directory node['nginx']['prefix'] + '/conf/' + node['nginx']['disabledconf_dir'] do
  action :create
end
directory node['nginx']['prefix'] + '/conf/' + node['nginx']['proxyconf_dir'] do
  action :create
end

file node['nginx']['doc_root'] + '/index.html' do
  source 'index.html'
end

if "#{isupgrade}" == "true"
      FileUtils.cp_r("#{node['nginx']['conf_backup']}", "#{node['nginx']['conf']}")
  service 'nginx' do
        action :restart
  end
else
    service 'nginx' do
    action [:enable, :start]
end
end
