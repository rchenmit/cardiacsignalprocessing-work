function [state] = kalm(aa)
%KALM Summary of this function goes here
%   Detailed explanation goes here

state = zeros(4,length(aa));
I = eye(4);
dt = 1;
F = [1 dt dt^2/2 dt^3/6;...
    0 1 dt dt^2/2;...
    0 0 1 dt;...
    0 0 0 1];
H = [0 0 1 0];

%estimate measurement error
jj = aa(2:end)-aa(1:end-1);
R = .1*var(jj);

%initialize
xx = [0 0 0 1]';
P = 100*I;
qj = var(jj(2:end)-jj(1:end-1));
Q = zeros(4);
Q(1,1) = qj/10;
Q(2,2) = qj/10;
Q(3,3) = qj/10;
Q(4,4) = qj;
for k = 1:length(aa)
    %predict
    xx = F*xx;
    P = F*P*F' + Q;
    
    %update
    y = aa(k) - H*xx;
    S = H*P*H'+R;
    K = P*H'*S^-1;
    xx = xx + K * y;
    P = (I-K*H)*P;
    state(:,k) = xx;
end
end

