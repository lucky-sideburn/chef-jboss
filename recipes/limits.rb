#
# Cookbook Name:: jboss
# Recipe:: limits
#
# Copyright (C) 2013 Eugenio Marzo, Damiano Scaramuzza
# 
# All rights reserved - Do Not Redistribute
#

has_limits = node['jboss']['has_limits']
limits = node['jboss']['limits']
jboss_app_name = node['jboss']['app_name']

if has_limits 
     template "/etc/security/limits.d/#{jboss_app_name}_limits.conf" do
        source "limits.conf.erb"
        mode "644"
        notifies :restart, "service[#{jboss_app_name}]"
     end
end
