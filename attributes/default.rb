#
# default attributes
#
default['jboss']['url'] = 'http://168.202.4.190/jboss-as-7.1.3.Final.tar.gz'
default['jboss']['version'] = '7.1.3'
default['jboss']['app_name'] = 'jboss'
default['jboss']['home'] = '/usr/local/jboss'
default['jboss']['user'] = 'jboss'
default['jboss']['group'] = 'jboss'
default['jboss']['config_file'] = "standalone-full.xml"
default['jboss']['script'] = "standalone.sh"

#users.properties.erb   ==> /usr/local/my_app/standalone/configuration/application-users.properties.erb
#roles.properties.erb   ==> /usr/local/my_app/standalone/configuration/application-roles.properties.erb
default['jboss']['users.properties'] = {}
default['jboss']['roles.properties'] = {}
#manage files with chef
default['jboss']['files'] = []

#default java opts
default['jboss']['java_opts'] =[
                                                 "-Xms128m",
                                                 "-XX:MaxPermSize=256m",
                                                 "-Xmx14G"
                                                                        ]

#setting folders with custom permissions
default['jboss']['custom-perms'] =[] 
  												
#set true if you use postgresql module
default['jboss']['has_pg'] = false
default['jboss']['postgresql']  = {
                                                   :url => "http://jdbc.postgresql.org/download/postgresql-9.2-1002.jdbc4.jar",
                                                   :jar => "postgresql-9.2-1002.jdbc4.jar",
                                                   :version => "9.2-1002.jdbc4",
                                                   :group_id => 'postgresql',
                                                   :package => 'org.postgresql',
                                                   :class => 'org.postgresql.Driver',
                                                   :dependencies => [ 'javax.api' ]     }



#Ulimits settings
#<domain>      <type>  <item>     <value>
#my_user       hard    nofile     10240
default['jboss']['has_limits'] = false 
default['jboss']['limits'] = [{
				   	 :user => "#{node['jboss']['user']}",  
                                    	 :type => "hard",
                                         :item => "nofile",
					 :value => "10240"
										 },
				  	    {
                                         :user => "#{node['jboss']['user']}", 
                                         :type => "soft",
                                         :item => "nofile",
                                         :value => "10240"
                                                                                 },
                                            							]
