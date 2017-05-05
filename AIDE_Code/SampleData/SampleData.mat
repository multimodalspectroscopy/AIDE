% Apply the Correlation Based Signal Improvement (CBSI) to HbO2 and HHb
% Developed by Cui et al.:
% % Cui, X., Bray, S., & Reiss, A. L. (2010). 
% % Functional near infrared spectroscopy (NIRS) signal improvement based on
% % negative correlation between oxygenated and deoxygenated hemoglobin dynamics. 
% % Neuroimage, 49(4), 3039-3046.

function [HBO_cbsi]= Cbsi(HBO,HBR)

HBO_cbsi=zeros(size(HBO,1),size(HBO,2));

for Ch = 1:size(HBO,2) % Channels
    
    HBO_std = std((HBO(:,Ch)-mean(HBO(:,Ch))),0,1);
    HBR_std = std((HBR(:,Ch)-mean(HBR(:,Ch))),0,1);
    
    a = HBO_std/HBR_std;
    HBO_cbsi(:,Ch) = 0.5*((HBO(:,Ch)-mean(HBO(:,Ch)))-a*(HBR(:,Ch)-mean(HBR(:,Ch))));
end

