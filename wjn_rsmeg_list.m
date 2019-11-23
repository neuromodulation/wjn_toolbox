function [output,p]=wjn_rsmeg_list(n,input,options,name)

try
    root = fullfile(mdf,'rsmeg');
    location_folder = fullfile(root,'Lokas');
    megfolder = fullfile(root,'megfiles');
catch
    location_folder = [];
    megfolder = [];
    root = cd;
end
drug = {'off','on'};
stim = {'off','on'};

freqbands = [3 45;5 7;8 12;13 20; 20 35;60 90];
%%

p(1).n = 1;
p(1).id = 'PLFP03';
p(1).group = 'PD';
p(1).center = 'Berlin';
p(1).target = 'STN';
p(1).age = 59;
p(1).sex = 'm';
p(1).lokafolder = fullfile(location_folder,'HeinA');
p(1).megfile = fullfile(megfolder,'PLFP03\PLFP03_on.mat');
p(1).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(1).coords_right = [ 
   10.4117  -13.5110   -9.2141
   11.1323  -12.6555   -7.7676
   11.8468  -11.7821   -6.3014
   12.5617  -10.8804   -4.7991 ];
p(1).coords_left = [  -10.7113  -14.7142  -10.1491
  -11.4434  -13.9529   -8.7231
  -12.1643  -13.2027   -7.2816
  -12.8826  -12.4458   -5.7949];


p(2).n = 2;
p(2).id = 'PLFP04';
p(2).group = 'Dystonia';
p(2).subgroup = 'generalized';
p(2).center = 'Berlin';
p(2).target = 'GPi';
p(2).age = 48;
p(2).sex = 'f';
p(2).lokafolder = fullfile(location_folder,'HeberlingVer');
p(2).megfile = fullfile(megfolder,'PLFP04\PLFP04_off.mat');
p(2).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(2).coords_right = [  21.7333   -6.2929   -6.9459
                       21.8103   -6.1032   -4.9564
                       21.8872   -5.9136   -2.9669
                       21.9642   -5.7240   -0.9774];
p(2).coords_left = [
                  -20.5178   -5.9395   -6.9822
                  -20.5955   -5.4138   -5.0541
                  -20.6732   -4.8881   -3.1259
                  -20.7508   -4.3623   -1.1978];



  
p(3).n = 3;
p(3).id = 'PLFP05';
p(3).group = 'PD';
p(3).center = 'Berlin';
p(3).target = 'STN';
p(3).age = 58;
p(3).sex = 'f';
p(3).lokafolder = []%fullfile(location_folder,'ChongR');
p(3).megfile = fullfile(megfolder,'PLFP05\PLFP05_on.mat');
p(3).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(3).coords_right = [ ];
p(3).coords_left = [];


p(4).n = 4;
p(4).id = 'PLFP06';
p(4).group = 'PD';
p(4).center = 'Berlin';
p(4).target = 'STN';
p(4).lokafolder = fullfile(location_folder,'RoseRichard');
p(4).megfile = fullfile(megfolder,'PLFP06\PLFP06_on.mat');
p(4).age = 72;
p(4).sex = 'm';
p(4).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(4).coords_right = [  11.6430  -13.6694   -8.1124
                       12.3059  -12.8106   -6.1985
                       12.9688  -11.9518   -4.2846
                       13.6317  -11.0931   -4.3707];
                   
p(4).coords_left = [  -10.5603  -13.8332   -9.0047
                  -11.3402  -12.9479   -7.2777
                  -12.1201  -12.0626   -5.5508
                  -12.8999  -11.1773   -4.8238];
            
p(5).n = 5;
p(5).id = 'PLFP07';
p(5).group = 'Dystonia';
p(5).center = 'Berlin';
p(5).target = 'GPi';
p(5).lokafolder = fullfile(location_folder,'AndersThomas');
p(5).megfile = fullfile(megfolder,'PLFP07\PLFP07_off.mat');
p(5).age = 55;
p(5).sex = 'm';
p(5).electrode = '3389';
p(5).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(5).coords_right = [   21.0980   -8.1802   -8.7068
                       21.1085   -7.5752   -6.3834
                       21.1189   -6.9702   -5.0600
                       21.1294   -6.3652   -1.7366];
p(5).coords_left = [
                      -22.2986   -7.8868   -7.7628
                      -22.3831   -7.3260   -5.4496
                      -22.4677   -6.7652   -5.1365
                      -22.5522   -6.2045   -0.8234];

       
 p(6).n = 6;
p(6).id = 'PLFP08';
p(6).group = 'Meige';
p(6).center = 'Berlin';
p(6).target = 'GPi';
p(6).lokafolder = fullfile(location_folder,'KismartonSab');
p(6).megfile = fullfile(megfolder,'PLFP08\PLFP08_off.mat');
p(6).age = 52;
p(6).sex = 'f';
p(6).electrode = '3389';
p(6).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(6).coords_right = [   20.2520   -8.3704   -7.8536
   20.5963   -7.4665   -6.7574
   20.9407   -6.5625   -3.6612
   21.2851   -6.6586   -1.5650];
p(6).coords_left = [
                      -21.6586   -7.9504   -6.9854
  -21.9921   -6.9257   -6.9706
  -22.3255   -6.9010   -2.9559
  -22.6589   -6.8763   -0.9411];
 
p(7).n = 7;
p(7).id = 'PLFP09';
p(7).group = 'cDYT';
p(7).center = 'Berlin';
p(7).target = 'GPi';
p(7).lokafolder = fullfile(location_folder,'LiebenowMart');
p(7).megfile = fullfile(megfolder,'PLFP09\PLFP09_off.mat');
p(7).age = 51;
p(7).sex = 'f';
p(7).electrode = '3389';
p(7).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(7).coords_right = [   21.4682   -7.5024   -7.5817
   21.9795   -6.1410   -4.8975
   22.4908   -4.7797   -2.2134
   23.0021   -3.4183    0.4708];
p(7).coords_left = [   -20.8873   -7.5589   -4.1312
  -20.9749   -5.8391   -0.7679
  -21.0625   -4.1193    2.5954
  -21.1501   -2.3995    5.9587];
                           
p(8).n = 8;
p(8).id = 'PLFP10';
p(8).group = 'cDYT';
p(8).center = 'Berlin';
p(8).target = 'GPi';
p(8).lokafolder = fullfile(location_folder,'JungeKarina');
p(8).megfile = fullfile(megfolder,'PLFP10\PLFP10_off.mat');
p(8).age = 52;
p(8).sex = 'f';
p(8).electrode = '3389';
p(8).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(8).coords_right = [      20.7477   -7.8921   -7.7536
   20.8584   -7.5718   -5.7825
   20.9691   -7.2514   -3.8115
   21.0797   -5.9311   -1.8404];
p(8).coords_left = [     -22.2681   -7.7489   -7.9099
  -22.3971   -7.3074   -5.9635
  -22.5262   -7.8659   -4.0172
  -22.6552   -7.4244   -2.0708];


p(9).n = 9;
p(9).id = 'PLFP11';
p(9).group = 'cDYT';
p(9).center = 'Berlin';
p(9).target = 'GPi';
p(9).lokafolder = fullfile(location_folder,'WobkerNeumanJ');
p(9).megfile = fullfile(megfolder,'PLFP11\PLFP11_off.mat');
p(9).age = 48;
p(9).sex = 'f';
p(9).electrode = '3389';
p(9).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(9).coords_right = [       21.1958   -9.2749   -9.3856
   21.3146   -9.5156   -5.5391
   21.4334   -6.7564   -3.6927
   21.5521   -5.9971   -1.8462];
p(9).coords_left = [       -21.4243   -9.3103   -9.1394
  -21.5410   -9.3923   -5.3664
  -21.6577   -9.4743   -3.5933
  -21.7744   -6.5563   -1.8203];


p(10).n = 10;
p(10).id = 'PLFP12';
p(10).group = 'cDYT';
p(10).center = 'Berlin';
p(10).target = 'GPi';
p(10).lokafolder = fullfile(location_folder,'SchnabelDiet');
p(10).megfile = fullfile(megfolder,'PLFP12\PLFP12_off.mat');
p(10).age = 68;
p(10).sex = 'm';
p(10).electrode = '3389';
p(10).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(10).coords_right = [         21.0381   -5.8483   -2.9989
   21.1766   -5.8052   -1.0042
   21.3152   -5.7621    0.9905
   21.4538   -5.7190    2.9852];
p(10).coords_left = [         -21.5288   -6.8243   -6.7572
  -21.8077   -6.4219   -4.8180
  -22.0867   -6.0195   -2.8789
  -22.3656   -5.6171   -0.9398];
   
p(11).n = 11;
p(11).id = 'PLFP13';
p(11).group = 'PD';
p(11).center = 'Berlin';
p(11).target = 'STN';
p(11).lokafolder = fullfile(location_folder,'RudianAndrea');
p(11).megfile = fullfile(megfolder,'PLFP13\PLFP13_on.mat');
p(11).age = 47;
p(11).sex = 'm';
p(11).electrode = '3389';
p(11).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(11).coords_right = [       
   11.5262  -16.9139  -11.5181
   11.1347  -15.9935   -8.5997
   11.7500  -15.0744   -6.6623
   12.3649  -14.1701   -4.6811];
p(11).coords_left = [             -11.6359  -16.0980   -11.0770
  -11.1803  -15.1056   -7.1609
  -11.7461  -14.0740   -5.2184
  -11.3038  -12.9971   -3.2572];

 
p(12).n = 12;
p(12).id = 'PLFP14';
p(12).group = 'PD';
p(12).center = 'Berlin';
p(12).target = 'STN';
p(12).lokafolder = fullfile(location_folder,'MuellerL');
p(12).megfile = fullfile(megfolder,'PLFP14\PLFP14_on.mat');
p(12).age = 50;
p(12).sex = 'm';
p(12).electrode = '3389';
p(12).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(12).coords_right = [         12.6842  -14.4817   -5.6000
   13.0062  -13.3130   -3.7931
   13.3282  -12.1442   -1.9862
   13.6502  -12.9755   -0.1792];
p(12).coords_left = [             -12.8517  -15.3606   -7.9500
  -12.4720  -14.0576   -6.2980
  -13.0923  -12.7546   -4.6460
  -13.7125  -12.4516   -2.9940];

p(13).n = 13;
p(13).id = 'PLFP15';
p(13).group = 'PD';
p(13).center = 'Berlin';
p(13).target = 'STN';
p(13).lokafolder = fullfile(location_folder,'BeyerL');
p(13).megfile = fullfile(megfolder,'PLFP15\PLFP15_off.mat');
p(13).age = 66;
p(13).sex = 'f';
p(13).electrode = '3389';
p(13).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(13).coords_right = [         19.8718   -8.5982   -5.6000
   20.1150   -7.9321   -3.5656
   20.3582   -7.2660   -1.5313
   20.6013   -6.5999    0.5031];
p(13).coords_left = [             -21.0579   -6.3915   -6.0500
  -21.2051   -5.5136   -4.1279
  -21.3523   -4.6357   -2.2058
  -21.4995   -3.7579   -0.2837];

p(14).n = 14;
p(14).id = 'PLFP16';
p(14).group = 'PD';
p(14).center = 'Berlin';
p(14).target = 'cZI';
p(14).lokafolder = fullfile(location_folder,'HaereckeEckh');
p(14).megfile = fullfile(megfolder,'PLFP16\PLFP16_on.mat');
p(14).age = 68;
p(14).sex = 'm';
p(14).electrode = '3389';
p(14).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(14).coords_right = [             9.8620  -20.4677  -11.3568
   10.3867  -19.2965   -9.6349
   10.9225  -18.1224   -7.9944
   11.4491  -16.9381   -6.4186];
p(14).coords_left = [               -14.6100  -19.3644  -11.3559
  -14.1246  -18.0257   -9.7038
  -14.6308  -16.6574   -8.1220
  -14.1181  -15.2604   -6.5955];


p(15).n = 15;
p(15).id = 'PLFP17';
p(15).group = 'PD';
p(15).center = 'Berlin';
p(15).target = 'STN';
p(15).lokafolder = []%fullfile(location_folder,'');
p(15).megfile = fullfile(megfolder,'PLFP17\PLFP17_on.mat');
p(15).age = 39;
p(15).sex = 'm';
p(15).electrode = '3389';
p(15).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(15).coords_right = [         ];
p(15).coords_left = [             ];

    
p(16).n = 16;
p(16).id = 'PLFP18';
p(16).group = 'DYT11';
p(16).center = 'Berlin';
p(16).target = 'GPi';
p(16).lokafolder = fullfile(location_folder,'SchonenbergM');
p(16).megfile = fullfile(megfolder,'PLFP18\PLFP18_off.mat');
p(16).age = 38;
p(16).sex = 'm';
p(16).electrode = '3389';
p(16).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(16).coords_right = [         19.2353   -8.1897   -9.5544
   19.6578   -7.4072   -7.5559
   20.0803   -6.6247   -5.5574
   20.5029   -5.8422   -3.5589];
p(16).coords_left = [       -19.1409   -8.4195   -8.5695
  -19.4252   -7.5155   -6.5841
  -19.7095   -6.6116   -4.5986
  -19.9938   -5.7077   -2.6131];

p(17).n = 17;
p(17).id = 'PLFP19';
p(17).group = 'PD';
p(17).center = 'Berlin';
p(17).target = 'STN';
p(17).lokafolder = fullfile(location_folder,'NickelHenry');
p(17).megfile = fullfile(megfolder,'PLFP19\PLFP19_off.mat');
p(17).age = 44;
p(17).sex = 'm';
p(17).electrode = '3389';
p(17).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(17).coords_right = [        17.0074  -14.4938  -10.2629
   17.3774  -13.7018   -8.4640
   17.7473  -12.9098   -6.6651
   17.1172  -12.1178   -4.8662];
p(17).coords_left = [        -11.9206  -12.1654   -6.9782
  -12.1017  -11.4009   -5.1390
  -12.2828  -10.6363   -3.2998
  -12.4638   -9.8717   -1.4606];
       

p(18).id = 'PLFP20';
p(18).n = 18;
p(18).group = 'Dystonia';
p(18).center = 'Berlin';
p(18).target = 'GPi';
p(18).lokafolder = fullfile(location_folder,'FiebigMaren');
p(18).megfile = fullfile(megfolder,'PLFP20\PLFP20_off.mat');
p(18).age = 47;
p(18).sex = 'f';
p(18).electrode = '3389';
p(18).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(18).coords_right = [    20.1147   -8.1726   -7.3790
                         20.3072   -7.3234   -5.0154
                        20.4997   -6.4743   -2.6518
                     20.6923   -5.6251   -0.2882];
p(18).coords_left = [  -21.9019   -9.1939   -7.1260
                      -21.8178   -7.9820   -4.9188
                      -21.7337   -6.7700   -2.7115
                      -21.6496   -5.5580   -0.5043];       


p(19).n = 19;
p(19).id = 'PLFP21';
p(19).group = 'PD';
p(19).center = 'Berlin';
p(19).target = 'STN';
p(19).lokafolder = fullfile(location_folder,'BrandtH');
p(19).megfile = fullfile(megfolder,'PLFP21\PLFP21_on.mat');
p(19).age = 69;
p(19).sex = 'm';
p(19).electrode = '3389';
p(19).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(19).coords_right = [       
    9.7229  -16.9959   -6.9476
   10.3734  -16.2059   -5.2285
   10.9889  -15.4191   -3.4940
   11.5717  -14.6040   -1.7049];
p(19).coords_left = [              -9.3705  -14.0538   -4.4847
   -9.9906  -12.8654   -3.0292
  -10.5611  -11.6369   -1.5129
  -11.0649  -10.3675    0.0535];

p(20).n = 20;
p(20).id = 'PLFP22';
p(20).group = 'cDYT';
p(20).center = 'Berlin';
p(20).target = 'GPi';
p(20).lokafolder = fullfile(location_folder,'RubenDetlef');
p(20).megfile = fullfile(megfolder,'PLFP22\PLFP22_off.mat');
p(20).age = 58;
p(20).sex = 'm';
p(20).electrode = '3389';
p(20).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(20).coords_right = [        21.7243   -8.6910   -7.3665
   21.8844   -7.4472   -5.5276
   22.0221   -6.2187   -3.6660
   22.1474   -5.0279   -1.8202];
p(20).coords_left = [           
  -20.4062   -6.7825   -8.3360
  -20.5195   -5.9482   -6.1440
  -20.6089   -5.0564   -3.8108
  -20.6612   -4.1962   -1.4394];

p(21).n = 21;
p(21).id = 'PLFP23';
p(21).group = 'PD';
p(21).center = 'Berlin';
p(21).target = 'cZI';
p(21).lokafolder = fullfile(location_folder,'BitterlichTi');
p(21).megfile = fullfile(megfolder,'PLFP23\PLFP23_on.mat');
p(21).age = 61;
p(21).sex = 'm';
p(21).electrode = '3389';
p(21).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(21).coords_right = [           10.2088  -18.0735   -8.4845
   10.8395  -16.7497   -6.8503
   11.5335  -15.5313   -5.3184
   12.2128  -14.3359   -3.8366];
p(21).coords_left = [           
  -10.7653  -21.1763   -6.1639
  -11.5287  -21.4521   -4.7545
  -12.3551  -18.7601   -3.3545
  -13.1603  -18.0145   -1.9183];



p(22).n = 22;
p(22).id = 'PLFP24';
p(22).group = 'PD';
p(22).center = 'Berlin';
p(22).target = 'STN';
p(22).lokafolder = fullfile(location_folder,'GadM');
p(22).megfile = fullfile(megfolder,'PLFP24\PLFP24_on.mat');
p(22).age = 54;
p(22).sex = 'm';
p(22).electrode = '3389';
p(22).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(22).coords_right = [           9.9874  -14.5861   -9.0069
   10.7555  -13.2450   -7.2716
   11.5487  -11.8462   -5.5455
   12.3738  -10.3899   -3.8393];
p(22).coords_left = [             -12.3306  -12.5758   -7.6106
  -13.0892  -11.3981   -5.7960
  -13.8569  -10.1995   -3.9642
  -14.6374   -8.9902   -2.1114];


p(23).n = 23;
p(23).id = 'PLFP25';
p(23).group = 'DYT1';
p(23).center = 'Berlin';
p(23).target = 'GPi';
p(23).lokafolder = fullfile(location_folder,'WitkowskaJus');
p(23).megfile = fullfile(megfolder,'PLFP25\PLFP25_off.mat');
p(23).age = 24;
p(23).sex = 'f';
p(23).electrode = '3389';
p(23).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(23).coords_right = [         18.6678   -5.6302   -7.9204
   19.2180   -5.1426   -6.0604
   19.7682   -4.6550   -4.2004
   20.3184   -4.1673   -2.3404];
p(23).coords_left = [             -19.4203   -6.3779   -7.0718
  -19.7689   -5.6340   -5.2483
  -20.1175   -4.8901   -3.4248
  -20.4661   -4.1462   -1.6013];


p(24).n = 24; %% OFF missing
p(24).id = 'PLFP26';
p(24).group = 'PD';
p(24).center = 'Berlin';
p(24).target = 'cZI';
p(24).lokafolder = fullfile(location_folder,'MattauschBer');
p(24).megfile = fullfile(megfolder,'PLFP26\PLFP26_on.mat');
p(24).age = 53;
p(24).sex = 'm';
p(24).electrode = '3389';
p(24).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(24).coords_right = [            12.0795  -16.8990   -7.6353
   12.6591  -15.7005   -6.2177
   13.2352  -14.4609   -4.8195
   13.7892  -13.1754   -3.4101];
p(24).coords_left = [              -12.4361  -17.5612   -8.3577
  -13.0995  -16.3582   -6.9503
  -13.7190  -15.1171   -5.5148
  -14.2813  -13.8416   -4.0372];


p(25).n = 25;
p(25).id = 'PLFP27';
p(25).group = 'PD';
p(25).center = 'Berlin';
p(25).target = 'STN';
p(25).lokafolder = fullfile(location_folder,'SchroderHans');
p(25).megfile =[];% fullfile(megfolder,'PLFP27\PLFP27_off.mat');
p(25).age = 0;
p(25).sex = 'm';
p(25).electrode = '3389';
p(25).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(25).coords_right = [          12.2134  -17.9584  -11.9772
   13.2132  -16.8803  -10.1284
   14.2252  -15.7997   -8.3191
   15.2404  -14.7255   -6.5395];
p(25).coords_left = [              -14.2289  -18.0829  -11.8214
  -15.0540  -17.0065   -9.9308
  -15.8929  -15.9199   -8.0646
  -16.7093  -14.8356   -6.2130];


p(26).n = 26;
p(26).id = 'PLFP28';
p(26).group = 'PD';
p(26).center = 'Berlin';
p(26).target = 'STN';
p(26).lokafolder = fullfile(location_folder,'Pfeilsticker');
p(26).megfile = []%fullfile(megfolder,'PLFP07\PLFP07_off.mat');
p(26).age = 0;
p(26).sex = 'm';
p(26).electrode = '3389';
p(26).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(26).coords_right = [            10.7149  -17.7782   -6.4799
   11.4640  -16.7918   -5.0213
   12.1294  -15.7981   -3.5146
   12.7184  -14.8040   -1.9595];
p(26).coords_left = [             
  -11.7144  -18.1342   -6.2061
  -12.4008  -17.2222   -4.7436
  -13.0321  -16.2878   -3.2183
  -13.6038  -15.3173   -1.6274];


p(27).n = 27;
p(27).id = 'PLFP29';
p(27).group = 'PD';
p(27).center = 'Berlin';
p(27).target = 'STN';
p(27).lokafolder = fullfile(location_folder,'JakumeitChri');
p(27).megfile = fullfile(megfolder,'PLFP29\PLFP29_on.mat');
p(27).age = 62;
p(27).sex = 'f';
p(27).electrode = '3389';
p(27).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(27).coords_right = [    10.2150  -14.6757   -9.7958
   10.7937  -13.2375   -7.8285
   11.4018  -11.7991   -5.8828
   12.0437  -10.3469   -3.9483
     ];
p(27).coords_left = [        -11.0658  -15.1941   -9.5705
  -11.6723  -13.7123   -7.6805
  -12.3044  -12.2239   -5.7864
  -12.9660  -10.7326   -3.8978      ];



p(28).n = 28;
p(28).id = 'PLFP30';
p(28).group = 'sDYT';
p(28).center = 'Berlin';
p(28).target = 'GPi';
p(28).lokafolder = fullfile(location_folder,'SellnowDirk');
p(28).megfile = fullfile(megfolder,'PLFP30\PLFP30_off.mat');
p(28).age = 0;
p(28).sex = 'm';
p(28).electrode = '3389';
p(28).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(28).coords_right = [         22.2780   -0.8096    1.1360
   22.5631    0.4202    3.8574
   22.8482    1.6500    6.5789
   23.1334    2.8798    9.3003];
p(28).coords_left = [            -24.9801   -2.6361   -7.5040
  -25.2407   -1.4122   -4.7774
  -25.5012   -0.1883   -2.0509
  -25.7618    1.0357    0.6757];



p(29).n = 29;
p(29).id = 'PLFP31';
p(29).group = 'PD';
p(29).center = 'Berlin';
p(29).target = 'STN';
p(29).lokafolder = fullfile(location_folder,'KolmWerner');
p(29).megfile = fullfile(megfolder,'PLFP31\PLFP31_on.mat');
p(29).age = 0;
p(29).sex = 'm';
p(29).electrode = '3389';
p(29).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(29).coords_right = [         11.0828  -13.9907   -9.1369
   11.7531  -13.0279   -7.3239
   12.4235  -12.0651   -5.5110
   13.0938  -11.1023   -3.6980];
p(29).coords_left = [            -11.4544  -15.2576   -9.0404
  -12.1181  -14.2217   -7.2442
  -12.7817  -13.1858   -5.4479
  -13.4454  -12.1498   -3.6517];


p(30).n = 30;
p(30).id = 'PLFP32';
p(30).group = 'PD';
p(30).center = 'Berlin';
p(30).target = 'STN';
p(30).lokafolder = fullfile(location_folder,'BirkLida');
p(30).megfile = fullfile(megfolder,'PLFP32\PLFP32_on.mat');
p(30).age = 0;
p(30).sex = 'f';
p(30).electrode = '3389';
p(30).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(30).coords_right = [   
   10.2909  -13.7267   -9.5120
   11.0095  -12.1729   -7.7864
   11.7574  -10.5977   -6.0866
   12.5104   -8.9785   -4.4102];
p(30).coords_left = [ 
  -10.7706  -14.2654   -9.8508
  -11.4027  -12.8736   -7.9391
  -12.0462  -11.4569   -6.0497
  -12.6778  -10.0120   -4.1642
];


p(31).n = 31;
p(31).id = 'PLFP33';
p(31).group = 'PD';
p(31).center = 'Berlin';
p(31).target = 'STN';
p(31).lokafolder = fullfile(location_folder,'MierswaRenat');
p(31).megfile = fullfile(megfolder,'PLFP33\PLFP33_on.mat');
p(31).age = 0;
p(31).sex = 'f';
p(31).electrode = '3389';
p(31).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(31).coords_right = [    
    9.9598  -15.6148   -9.2668
   10.7379  -14.5184   -7.2480
   11.5084  -13.4195   -5.2465
   12.2870  -12.2884   -3.2379    ];
p(31).coords_left = [       -10.6501  -14.5623   -8.6095
  -11.4265  -13.6498   -6.3626
  -12.1870  -12.7038   -4.1621
  -12.9453  -11.7231   -1.9464       ];


p(32).n = 32;
p(32).id = 'PLFP34';
p(32).group = 'PD';
p(32).center = 'Berlin';
p(32).target = 'STN';
p(32).lokafolder = fullfile(location_folder,'DalkKarin');
p(32).megfile = fullfile(megfolder,'PLFP34\PLFP34_on.mat');
p(32).age = 73;
p(32).sex = 'f';
p(32).electrode = '3389';
p(32).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(32).coords_right = [        11.6842  -14.7546   -9.7654
   12.2538  -13.4416   -7.9465
   12.8869  -12.1422   -6.1797
   13.5631  -10.8274   -4.4504];
p(32).coords_left = [            -11.5666  -14.6621  -11.0704
  -12.3362  -13.2736   -9.3187
  -13.1826  -11.9247   -7.6194
  -14.0751  -10.5772   -5.9521];



p(33).n = 33;
p(33).id = 'PLFP35';
p(33).group = 'PD';
p(33).center = 'Berlin';
p(33).target = 'STN';
p(33).lokafolder = fullfile(location_folder,'Helmecke_Lutz');
p(33).megfile = []%fullfile(megfolder,'PLFP07\PLFP07_off.mat');
p(33).age = 58;
p(33).sex = 'm';
p(33).electrode = 'BV';
p(33).contact_pairs = {};
p(33).coords_right = [         9.9249  -13.9417  -11.5244
   10.7232  -13.0306   -9.8526
   11.5215  -12.1195   -8.1808
   12.3198  -11.2084   -6.5090
   13.1181  -10.2973   -4.8372
   13.9164   -9.3862   -3.1654
   14.7147   -8.4751   -1.4936
   15.5130   -7.5640    0.1782];
p(33).coords_left = [             -11.4902  -14.6804  -11.9577
  -12.0809  -13.7245  -10.1658
  -12.6717  -12.7687   -8.3740
  -13.2624  -11.8129   -6.5821
  -13.8531  -10.8570   -4.7903
  -14.4438   -9.9012   -2.9985
  -15.0345   -8.9454   -1.2066
  -15.6252   -7.9895    0.5852];



p(34).n = 34;
p(34).id = 'PLFP36';
p(34).group = 'sDYT';
p(34).center = 'Berlin';
p(34).target = 'GPi';
p(34).lokafolder = fullfile(location_folder,'MatzackKarin');
p(34).megfile = []%fullfile(megfolder,'PLFP07\PLFP07_off.mat');
p(34).age = 49;
p(34).sex = 'f';
p(34).electrode = 'BV';
p(34).contact_pairs = {};
p(34).coords_right = [         20.5565   -8.3322   -9.3998
   20.8737   -7.6383   -7.3069
   21.1909   -6.9444   -5.2140
   21.5081   -6.2504   -3.1211
   21.8253   -5.5565   -1.0282
   22.1425   -4.8625    1.0646
   22.4597   -4.1686    3.1575
   22.7769   -3.4746    5.2504];
p(34).coords_left = [             -21.1033   -9.1709   -7.9582
  -21.2721   -8.4635   -5.8541
  -21.4409   -7.7561   -3.7500
  -21.6096   -7.0487   -1.6459
  -21.7784   -6.3413    0.4582
  -21.9472   -5.6339    2.5623
  -22.1160   -4.9264    4.6665
  -22.2847   -4.2190    6.7706];


p(35).n = 35;
p(35).id = 'PLFP37';
p(35).group = 'PD';
p(35).center = 'Berlin';
p(35).target = 'STN';
p(35).lokafolder = fullfile(location_folder,'KahlAnnegret');
p(35).megfile = fullfile(megfolder,'PLFP37\PLFP37_on.mat');
p(35).age = 63;
p(35).sex = 'f';
p(35).electrode = '3389';
p(35).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(35).coords_right = [         11.0896  -15.7467   -8.0218
   11.9158  -14.7991   -5.9941
   12.6802  -13.8790   -4.0316
   13.3575  -12.8932   -2.0761];
p(35).coords_left = [             -11.6005  -15.5659   -7.7642
  -12.2812  -14.6388   -5.7272
  -12.9429  -13.6661   -3.6934
  -13.5686  -12.6528   -1.6491];


p(36).n = 36;
p(36).id = 'PLFP38';
p(36).group = 'PD';
p(36).center = 'Berlin';
p(36).target = 'STN';
p(36).lokafolder = fullfile(location_folder,'LempertPeter');
p(36).megfile = fullfile(megfolder,'PLFP38\PLFP38_on.mat');
p(36).age = 0;
p(36).sex = 'm';
p(36).electrode = '3389';
p(36).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(36).coords_right = [         10.2518  -13.2697   -7.3940
   10.7739  -12.9932   -5.4833
   11.2960  -12.7168   -3.5725
   11.8181  -12.4403   -1.6618];
p(36).coords_left = [             -10.4777  -14.4542   -9.1345
  -10.9790  -13.9548   -7.2638
  -11.4803  -13.4554   -5.3932
  -11.9817  -12.9560   -3.5225];


p(37).n = 37;
p(37).id = 'PLFP39';
p(37).group = 'gDYT';
p(37).center = 'Berlin';
p(37).target = 'GPi';
p(37).lokafolder = fullfile(location_folder,'HerzogGerda');
p(37).megfile = []%fullfile(megfolder,'PLFP07\PLFP07_off.mat');
p(37).age = 0;
p(37).sex = 'f';
p(37).electrode = '3389';
p(37).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(37).coords_right = [         17.8350   -8.6783   -9.7308
   18.2922   -7.7179   -7.5575
   18.7494   -6.7574   -5.3842
   19.2066   -5.7970   -3.2109];
p(37).coords_left = [             -22.3864   -9.1339   -8.1087
  -22.5882   -8.2109   -5.7360
  -22.7901   -7.2878   -3.3633
  -22.9919   -6.3648   -0.9907];

p(38).n = 38;
p(38).id = 'PLFP40';
p(38).group = 'ET';
p(38).center = 'Berlin';
p(38).target = 'VIM';
p(38).lokafolder = []%fullfile(location_folder,'');
p(38).megfile = fullfile(megfolder,'PLFP40\PLFP40_off.mat');
p(38).age = 54;
p(38).sex = 'm';
p(38).electrode = '3389';
p(38).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_L01','LFP_L12','LFP_L23'};
p(38).coords_right = [         ];
p(38).coords_left = [             ];

p(39).n = 39;
p(39).id = 'PLFP41';
p(39).group = 'PD';
p(39).center = 'Berlin';
p(39).target = 'STN';
p(39).lokafolder =fullfile(location_folder,'Ott');
p(39).megfile = fullfile(megfolder,'PLFP41\PLFP41_on.mat');
p(39).age = 52;
p(39).sex = 'm';
p(39).electrode = 'BS_directional';
p(39).contact_pairs = {'LFP_R18','LFP_L18'};
p(39).coords_right = [       11.6182  -14.6371   -9.0400
     14.0345  -11.3964   -3.6519     ];
%    12.4035  -13.5015   -7.2453
%    13.2180  -12.3970   -5.4758
%    14.0345  -11.3964   -3.6519     ];
p(39).coords_left = [        -12.2943  -14.2075   -7.9035
      -14.0862  -10.9572   -2.9588       ];
%   -12.9320  -13.0636   -6.2564
%   -13.5448  -11.9675   -4.6515
%   -14.0862  -10.9572   -2.9588       ];

p(40).n = 40;
p(40).id = 'PLFP42';
p(40).group = 'PD';
p(40).center = 'Berlin';
p(40).target = 'STN';
p(40).lokafolder = [];%fullfile(location_folder,'');
p(40).megfile = fullfile(megfolder,'PLFP42\PLFP42_on.mat');
p(40).age = 53;
p(40).sex = 'm';
p(40).electrode = 'BS_directional';
p(40).contact_pairs = {'LFP_R18','LFP_L18'};
p(40).coords_right = [         ];
p(40).coords_left = [             ];

p(41).n = 41;
p(41).id = 'PLFP43';
p(41).group = 'PD';
p(41).center = 'Berlin';
p(41).target = 's';
p(41).lokafolder = [];%fullfile(location_folder,'');
p(41).megfile = fullfile(megfolder,'PLFP07\PLFP07_off.mat');
p(41).age = 67;
p(41).sex = 'm';
p(41).electrode = 'BS_directional';
p(41).contact_pairs = {'LFP_R18','LFP_L18'};
p(41).coords_right = [         ];
p(41).coords_left = [             ];

p(42).n = 42;
p(42).id = 'PLFP44';
p(42).group = 'PD';
p(42).center = 'Berlin';
p(42).target = 'STN';
p(42).lokafolder = fullfile(location_folder,'Schröter');
p(42).megfile = fullfile(megfolder,'PLFP44\PLFP44_on.mat');
p(42).age = 69;
p(42).sex = 'm';
p(42).electrode = 'BS_directional';
p(42).contact_pairs = {'LFP_R18','LFP_L18'};
p(42).coords_right = [      11.1150  -14.0239  -11.5917
   11.9394  -13.5416   -9.1023
   11.0806  -12.5087   -9.5724
   12.2862  -12.5993  -10.0678
   12.6150  -12.4006   -7.1063
   11.7468  -11.3792   -7.5431
   12.9544  -11.4611   -8.0517
   13.1197  -10.5990   -5.5586      ];
p(42).coords_left = [       -10.8320  -13.9301  -13.1313
  -11.7564  -13.4592  -10.5313
  -11.0170  -12.5613  -10.7704
  -12.1655  -12.6449  -11.5261
  -12.6088  -12.4116   -8.4622
  -11.8564  -11.5202   -8.6682
  -13.0128  -11.5898   -9.4451
  -13.3500  -10.7744   -6.8276       ];

% p(43).n = 43;
% p(43).id = 'PLFP45';
% p(43).group = 'sDYT';
% p(43).center = 'Berlin';
% p(43).target = 'GPi';
% p(43).lokafolder = [];%fullfile(location_folder,'');
% p(43).megfile = fullfile(megfolder,'PLFP45\PLFP45_off.mat');
% p(43).age = 64;
% p(43).sex = 'f';
% p(43).electrode = 'BV';
% p(43).contact_pairs = {'LFP_R01','LFP_R12','LFP_R23','LFP_R34','LFP_R45','LFP_R56','LFP_R67','LFP_L01','LFP_L12','LFP_L23','LFP_L34','LFP_L45','LFP_L56','LFP_L67' };
% p(43).coords_right = [         ];
% p(43).coords_left = [             ];




for a =1:length(p)
    ids{a} = p(a).id;
end

if exist('n','var') && ischar(n)
    i = ci(n,ids);
    if ~isempty(i)
        output = i;
        return
    end
end

pfields={};
for a =1:length(p)
    pfields = [pfields;fieldnames(p(a))];
end
allfields = unique(pfields);
if exist('n','var') 
    if isnumeric(n) && ~exist('input','var') && n >=1
        output = p(n);
        return
    elseif isnumeric(n) && n >=1 && ismember(input,fieldnames(p(n)))
        output = p(n).(input);
        return
    elseif isnumeric(n) && n >=1 && isfield(p(n),'drug') && ismember(input,fieldnames(p(n).('drug')))
        output = p(n).(drug).(input);
        return
    elseif isnumeric(n) && n >=1 && ismember(input,allfields) && ~ismember(input,fieldnames(p(n)))
        output = 0;
        return
    elseif ~isnumeric(n)
        input = n;
    end
        switch input
           
            case 'list'
                nn=0;
                for a=1:length(p)
                    if p(a).n>0
                        nn=nn+1;
                        output{nn,3} = p(a).id;
                        output{nn,1} = a;
                        output{nn,2} = nn;
                    end
                end
            case 'root'
                output = root;
            case 'roifolder'
                output = fullfile(root,'ROIs',p(n).id);
            case 'freqbands'
                output = freqbands;
            case 'freqfolder'
                for a = 1:size(freqbands,1)
                    output{a} = ['band_' num2str(freqbands(a,1)) '_' num2str(freqbands(a,2)) 'Hz'];
                end
            case 'contact_pair_locations'
                
                    output = [wjn_rsmeg_contact2contactpair(p(n).coords_right) ; wjn_rsmeg_contact2contactpair(p(n).coords_left)];
 
            case 'rscohmappairs'
                nn=0;
                for a = 1:size(freqbands,1)
                    for b = 1:length(p(n).contact_pairs)
                        nn=nn+1;
                        output{nn,1} = fullfile(root,'cohmaps',p(n).id,['COH_' p(n).target '_' p(n).id '_' p(n).contact_pairs{b} '_band_' num2str(freqbands(a,1)) '_' num2str(freqbands(a,2)) 'Hz.nii']);
                        output{nn,2} = fullfile(root,'rsmaps',p(n).id,['mni_s' p(n).target '_' p(n).id '_' p(n).contact_pairs{b} '_roi_func_seed_AvgR.nii']);
                         output{nn,3} = ['rscohmap_' p(n).target '_' p(n).id '_' p(n).contact_pairs{b} '_band_' num2str(freqbands(a,1)) '_' num2str(freqbands(a,2)) 'Hz.nii'];
                    end
                end
            case 'update'
                copyfile(fullfile(getsystem,'wjn_rsmeg_list.m'),fullfile(getsystem,'wjn_toolbox'),'f');
                disp('copied to wjn_toolbox')
        end
        if ~exist('output','var')
            output = [];
            warning('output not assigned')
        end
else
    output = p;
end

