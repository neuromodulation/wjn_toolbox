

electrodetext = fullfile('E:\Dropbox\Motorneuroscience\ecog_berlin\Imaging\N1\Electrodes.txt');
preopmri = 'anat_t1.nii';
postopct = 'rpostop_ct.nii';

elec = readtable(electrodetext);
elec.Properties.VariableNames = {'Channel','X','Y','Z'};
nii = ea_load_nii(postopct);
if ~any(any(floor([elec.X elec.Y elec.Z])==[elec.X elec.Y elec.Z])) && min(min([elec.X elec.Y elec.Z]))>=1      
        vx = [elec.X elec.Y elec.Z ones(size(elec(:,1)))];
        nat=[];
        for a=1:size(vx,1)
        nat(a,:) = vx(a,:)*nii.mat';
        end
        elec.vxX = elec.X;
        elec.vxY = elec.Y;
        elec.vxZ = elec.Z;
        elec.natX = nat(:,1);
        elec.natY = nat(:,2);
        elec.natZ = nat(:,3);
else
        nat = [elec.X elec.Y elec.Z ones(size(elec(:,1)))];
        vx=[];
        for a=1:size(vx,1)
        vx(a,:) = round(nat(a,:)/nii.mat');
        end
        elec.natX = elec.X;
        elec.natY = elec.Y;
        elec.natZ = elec.Z;
        elec.vxX = vx(:,1);
        elec.vxY = vx(:,2);
        elec.vxZ = vx(:,3);   
end


