function wjn_write_txt(filename,data)

fid = fopen(filename,'wt');

fwrite(fid,data);

fclose(fid);