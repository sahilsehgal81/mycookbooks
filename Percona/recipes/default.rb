# inlcude_recipe "php5"
script "install_program" do
  not_if {File.exists?('/Percona-Server-server-56')}
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
    yum -y install Percona-Server-server-56 Percona-Server-client-56 Percona-Server-devel-56 Percona-Server-shared-56
     EOH
end

# setup the main server config file
template '/etc/my.cnf' do
  source "my.cnf.erb"
  notifies :restart, "service[mysql]", :immediately if node["percona"]["auto_restart"]
end

# define the service
service "mysql" do
  action :restart
end

#Assigning a Secure Password to MySQL
script "encr_mysql_pass" do
 not_if {File.exists?('/root/.mysql')}
 interpreter "bash"
 user "root"
 cwd "/root"
 code <<-EOH
    openssl rand -base64 12 > .mysql
    mysqladmin -u root password $(cat .mysql)
    EOH
end

