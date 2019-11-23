function [ampthresh, flatthresh] = berlin_gain(gainfile)

fid = fopen(gainfile);
fgetl(fid);
ampthresh  = 0.45*1e3*sscanf(fgetl(fid), 'Dynamic range: %f pT');
flatthresh = 1e4*sscanf(fgetl(fid), 'LSB: %f pT');
fclose(fid);