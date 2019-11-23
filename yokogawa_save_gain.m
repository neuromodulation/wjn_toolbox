function [] = yokogawa_save_gain(confile,gainfile)
     try
        fid = fopen(confile);
   
            amp_gain = GetMeg160AmpGainM(fid); 

        % from old yokogawa TB, found in FieldTrip
        amp_gain(1);
        fclose(fid);
        fid = fopen( gainfile,'w' );
        fprintf(fid,'Gain: %s\n',num2str(amp_gain(1)) );
        fprintf(fid,'Dynamic range: %s pT\n',num2str(550.0*10*1.02/amp_gain(1)) );
        fprintf(fid,'LSB: %s pT\n',num2str(550*10*1.02/(amp_gain(1)*2^16)) );
        fclose(fid);
     catch 
        disp('take template gain')
            copyfile('D:\MEG\plfp1_spm\SPM\gain.txt',gainfile)
    end
end