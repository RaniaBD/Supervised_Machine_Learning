path (path, './toolbox_general/')
path (path, './toolbox_signal/')

n= 256;
f0 = imread("toolbox_signal/cameraman.png");
imshow(f0,[]);

f0 = double(imread("toolbox_signal/cameraman.png"));
f0 = f0(1:n,1:n);
clf;

S=[];

for rho = 0.1:0.1:0.9, 

    %rgo = .1;
    Lambda = rand(n,n)>rho;
    Phi = @(f)f.*Lambda;

    y = Phi(f0);
    figure(1)
    imshow(y,[]);

    SoftThresh= @(x ,T)x.*max(0, 1-T./max(abs(x),1e-10));
    
    Jmax = log2 (n)-1;
    Jmin = Jmax-3;
    options.ti = 0;
    Psi = @(a)perform_wavelet_transf(a, Jmin ,-1, options);
    PsiS = @(f)perform_wavelet_transf(f ,Jmin , +1, options);

    SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T));

    y0=y;
    for i =1:100,
        y0 = SoftThreshPsi(y0,2);
    end
    
    fOn=rescale(f0,0,255);
    yOn=rescale(y0,0,255);
    
    S=[S snr(fOn,yOn)];
    
end

figure(2)
imshow(y0,[])

figure(3);
plot(0.1:0.1:0.9, S);
