# IF returns the limit has been configured
def check_limits (limits)
  limits.each do |l|
    
   case l[:item] 
     when "nofile"
       cmd = `su #{l[:user]} -c "ulimit -n"`
       log "[[COOKBOOK-DEBUG]] su #{l[:user]} -c 'ulimit -n'  => #{cmd}"

     when "nproc"
       cmd = `su #{l[:user]} -c "ulimit -u"`
       log "[[COOKBOOK-DEBUG]] su #{l[:user]} -c 'ulimit -u'  => #{cmd}" 
     
     else
       log "[[COOKBOOK-DEBUG]] not found a command to check this kind of limits. Please review check_limits in jboss::limits.rb "
       return true
   end


    if cmd.to_s == l[:value].to_s
      log "[[COOKBOOK-DEBUG]] found limit configuration for #{l[:user]}"
      return true
    end
  
  end
return false
end

