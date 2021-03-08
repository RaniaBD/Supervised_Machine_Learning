path (path, './toolbox_general/')
path (path, './toolbox_signal/')

n = 256;
f0 = double(imread("toolbox_signal/cameraman.png"));
f0 = f0(1:n,1:n);
clf;


rho=.8;
lambda = rand(n,n)>rho;
Phi = @(f)f.*lambda;
y = Phi(f0);


K = @(f)grad(f);
KS = @(u)-div(u);
Amplitude = @(u)sqrt(sum(u.^2,3));
F = @(u)sum(sum(Amplitude(u)));

ProxF = @(u,lambda)max(0,1-lambda./repmat(Amplitude(u),[1 1 2])).*u;
ProxFS = @(y,sigma)y-sigma*ProxF(y/sigma,1/sigma);
ProxG = @(f,tau)f+Phi(y-Phi(f));

L=8;
sigma=1;
tau = .9 / (L*sigma);
theta = 1;
f = y;
g = K(y)*0;
f1 = f;



n_iter = 1500;
E = [];

for i=1:n_iter    
    fold = f;
    g = ProxFS( g+sigma*K(f1), sigma);
    f = ProxG(  f-tau*KS(g), tau);
    f1 = f + theta * (f-fold);
    
    E(i) = F(K(f));
end

figure(1)
imshow([f0 y f],[]);





