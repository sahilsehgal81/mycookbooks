#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2014, Kayako Helpdesk Pvt LTD
#
# All rights reserved - Do Not Redistribute
#
package "ntp" do
    action [:install]
end
 
template "/etc/ntp.conf" do
    source "ntp.conf.erb"
    variables( :ntp_server => "3.in.pool.ntp.org" )
    notifies :restart, "service[ntpd]"
end
 
service "ntpd" do
    action [:enable,:start]
end
