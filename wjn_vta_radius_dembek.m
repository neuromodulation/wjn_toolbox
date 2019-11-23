function r=wjn_vta_radius_dembek(U,Im, ethresh, pw, ethresh_pw)
% This function radius of Volume of Activated Tissue for stimulation settings U and Ohm. See Maedler 2012 for details.
% Clinical measurements of DBS electrode impedance typically range from
% 500?1500 Ohm (Butson 2006).
r=0; %
if U %(U>0)
r = ((pw/ethresh_pw)^0.3) * sqrt((0.72 * (U/Im)) / (ethresh * 1000));
r= r * 1000; % from m to mm
end