function matdelete(fname)

script = wjn_find_script(fname)
y=input('Delete?','s')
if strcmp(y,'y')
    for a = 1:length(script)
        delete(fullfile(getsystem,script{a}))
        warning([script{a} 'deleted.'])
    end
end