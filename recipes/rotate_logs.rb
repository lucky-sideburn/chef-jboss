#
# Cookbook Name:: -jboss
# Recipe:: rotate_logs
#
# Copyright (C) 2013 Eugenio Marzo, Damiano Scaramuzza
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "logrotate"
include_recipe "janitor"


jboss_user = "#{node['jboss']['user']}"
jboss_group = "#{node['jboss']['group']}"
jboss_home = "#{node['jboss']['home']}"


logrotate_app jboss_user  do
  cookbook "logrotate"
  path     "#{jboss_home}/standalone/log/console.log"
  frequency "daily"
  rotate    30
  create    "664 #{jboss_user} #{jboss_group}"
end

# cleans up an early cron job b4 using janitor
cron "compress rotated esb log" do
  action :delete
end

janitor_logs "#{jboss_home}/standalone/log" do
  include_files ["*", "*.txt"]
  exclude_files [ "console.log", "boot.log" ]
  max_age 30
  min_age 1
  action [:compress,:purge]
end

