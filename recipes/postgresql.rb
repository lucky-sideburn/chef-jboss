#
# Cookbook Name:: jboss
# Recipe:: postgresql
#
# Copyright (C) 2013 Eugenio Marzo, Damiano Scaramuzza
# 
# All rights reserved - Do Not Redistribute
#
jboss_user = node['jboss']['user']
jboss_group = node['jboss']['group']
jboss_home = node['jboss']['home']
jboss_app_name = node['jboss']['app_name']
jboss_url = node['jboss']['url']
jboss_version = node['jboss']['version']

jar_name = node['jboss']['postgresql']['jar']
pg = node['jboss']['postgresql']



log "[DEV-LOGGING] postgresql module jar name =>#{jar_name}"
log "[DEV-LOGGING] postgresql module url of jar =>#{node['jboss']['postgresql']['url']}"

directory "#{jboss_home}/modules/org/postgresql/main" do
  group "#{jboss_group}"
  owner "#{jboss_user}"
  recursive true
  mode "0775"
end

remote_file "#{jboss_home}/modules/org/postgresql/main/#{jar_name}" do
  source  "#{node['jboss']['postgresql']['url']}"
  group "#{jboss_group}"
  owner "#{jboss_user}"
  mode "0775"
  action :create_if_missing
  notifies :restart, "service[#{jboss_app_name}]"
end

# jboss needs module.xml that matches the jdbc driver
template "#{jboss_home}/modules/org/postgresql/main/module.xml" do
  source "module.xml.erb"
  variables( :name => "postgresql", :mod => pg )
  owner "#{jboss_user}"
  group "#{jboss_group}"
  notifies :restart, "service[#{jboss_app_name}]"
end

