clc 
clear all
close all

% Load the data where I saved the interpolated coverage points based on the
% digitized Pressure - Coverage Isotherms. I interpolated points for
% different pressures
load Ptc.mat

% In this code, I'm interpolating at temperatures I want to get the saturation
% coverage using the Cov and Temps from the German paper at P = 1e-5 mbar

cov_sat = interp1(T,cov, [450, 460, 470, 475, 480, 490]);


save('expected_coverage.mat', "cov_sat")