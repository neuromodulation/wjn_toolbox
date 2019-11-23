function [ampthresh, flatthresh] = berlin_gain(gainfile)

fid = fopen(gainfile);
fgetl(fid);
ampthresh  = 0.45*1e3*sscanf(fgetl(fid), 'Dynamic range: %f pT');
flatthresh = 1e4*sscanf(fgetl(fid), 'LSB: %f pT');
fclose(fid);

for n0=-1:-1*nsubj %
    range =  data_set(5,n0);
    for n1 = range{1}(1):range{1}(2)
            
        fid = fopen(['/auge22/plfp1_spm/' char( data_set(4,n0) ) '/' char( data_set(1,n0) ) '/Raw/' char( data_set(2,n0)) '.' char(block_nr(n1)) '.con']);
        amp_gain = GetMeg160AmpGainM(fid);
        amp_gain(1)
        fclose(fid);
        fid = fopen(['/auge22/plfp1_spm/' char( data_set(4,n0) ) '/' char( data_set(1,n0) ) '/Raw/' char( data_set(2,n0)) '.' char(block_nr(n1)) '.gain.txt'],'w' );
        fprintf(fid,'Gain: %s\n',num2str(amp_gain(1)) );
        fprintf(fid,'Dynamic range: %s pT\n',num2str(550.0*10*1.02/amp_gain(1)) );
        fprintf(fid,'LSB: %s pT\n',num2str(550*10*1.02/(amp_gain(1)*2^16)) );
        fclose(fid);
     end 
end