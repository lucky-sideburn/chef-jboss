#
# Cookbook Name:: jboss
# Recipe:: default
#
# Copyright (C) 2013 Eugenio Marzo, Damiano Scaramuzza
# 
# All rights reserved - Do Not Redistribute
#
package "crontabs"

jboss_user = node['jboss']['user']
jboss_group = node['jboss']['group']
jboss_home = node['jboss']['home']
jboss_app_name = node['jboss']['app_name']
jboss_url = node['jboss']['url']
jboss_version = node['jboss']['version']
jboss_config_file = node['jboss']['config_file']
jboss_script = node['jboss']['script']

if Chef::Config[:solo]
	#create user and group
	user "#{jboss_user}"
	group "#{jboss_group}"
else
	include_recipe "sudo"
	include_recipe "users"

	users_manage_noid jboss_user do
  	  action [ :remove, :create ]
	end
end

#add sudoers
sudo jboss_user do

  template "app.erb"
  variables(
              {
                "name" => jboss_user,
                "service" => jboss_user
              }
            )
end



#extracting jboss
ark "jboss" do
 url          "#{jboss_url}"
 version      "#{jboss_version}"
 prefix_home  "#{jboss_app_name}"
 home_dir     "#{jboss_home}"
 owner        "#{jboss_user}"
 group        "#{jboss_group}"
 notifies :create,"directory[#{jboss_home}]"
 notifies :create,"ruby_block[custom_permissions]"
end


#setting recursive permissions to /usr/local/MY_APP
directory "#{jboss_home}" do
  group "#{jboss_user}"
  owner "#{jboss_group}"
  recursive true
  action :nothing
end


#setting custom permissions
ruby_block "custom_permissions" do
 block do
 require 'fileutils'
    node['jboss']['custom_perms'].each do |f|
      if File.exist? f[:path]
        FileUtils.chmod_R f[:perms].to_i, f[:path]
      end
    end
  end
#action :nothing
end



#install posgresql module
if node['jboss']['has_pg'] == true
 include_recipe "jboss::postgresql"
end



#init script creation
template "/etc/init.d/#{jboss_app_name}" do
  source "init_standalone_el.erb"
  mode "0755"
  owner "root"
  group "root"
  notifies :restart, "service[#{jboss_app_name}]"
end


# template environment variables used by init file
template "/etc/default/#{jboss_app_name}" do
  source "default.erb"
  mode "0755"
  variables( :config_file_name => jboss_config_file,
             :jboss_user => jboss_user,
             :jboss_home => jboss_home,
             :script => jboss_script )
  notifies :restart, "service[#{jboss_app_name}]"
end


if node['jboss']['users.properties'][:username]
 #TEMPLATE FOR => /usr/local/catalog/standalone/configuration/application-users.properties.erb
  template "#{jboss_home}/standalone/configuration/application-users.properties" do
   source "application-users.properties.erb"
   mode "0755"
   variables( :username =>  node['jboss']['users.properties'][:username],
              :hex  =>      node['jboss']['users.properties'][:hex]  )
   notifies :restart, "service[#{jboss_app_name}]"
 end
end


if node['jboss']['roles.properties'][:username]
 #TEMPLATE_FOR => /usr/local/catalog/standalone/configuration/application-roles.properties.erb
  template "#{jboss_home}/standalone/configuration/application-roles.properties" do
   source "application-roles.properties.erb"
   mode "0755"
   variables( :username => node['jboss']['roles.properties'][:username],
 	      :roles => node['jboss']['roles.properties'][:roles].join(",").to_s )
    notifies :restart, "service[#{jboss_app_name}]"
 end
end



node['jboss']['files'].each do |f|

 cookbook_file "#{f[:path]}/#{f[:name]}" do
   path "#{f[:path]}/#{f[:name]}"
   owner jboss_user
   group jboss_group
   notifies :restart, "service[#{jboss_app_name}]"
 end

end



# start service
service "#{jboss_app_name}" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable, :start ]
end



