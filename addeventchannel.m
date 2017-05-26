function addeventchannel(file,varname,varin)
    assignin('base',varname,varin);
    evalin('base',varname);
    save(file,varname,'-append');