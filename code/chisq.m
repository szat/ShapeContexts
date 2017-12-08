function [D] = chisq(X,Y)
%From Peter Kovesi
%%% supposedly it's possible to implement this without a loop!
m = size(X,1);  n = size(Y,1);
mOnes = ones(1,m); D = zeros(m,n);
for i=1:n
  yi = Y(i,:);  yiRep = yi( mOnes, : );
  s = yiRep + X;    d = yiRep - X;
  D(:,i) = sum( d.^2 ./ (s+eps), 2 );
end
D = D/2;

%Without a loop: seems slower!?
% m = size(X,1);
% n = size(Y,1);
% Xrep = kron(X,ones(n,1));
% Yrep = repmat(Y,m,1);
% chi = sum(((Xrep - Yrep).^2)./(Xrep + Yrep + eps),2)/2;
% D = vec2mat(chi,n);

end

