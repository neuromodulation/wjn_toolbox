function [root]=get_root; 
try
        load fff root
        
    catch
        [mf,dbf] = getsystem;
        root = uigetdir;
%         [~,folder]=fileparts(ff)
        save fff root
end