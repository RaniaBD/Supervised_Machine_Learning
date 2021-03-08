%% Perform the dictionary learning by iterating between sparse coding and 
%% dictionary update.

select = @(A,k)repmat(A(k,:), [size(A,1) 1]);
ProjX = @(X,k)X .* (abs(X) >= select(sort(abs(X), 'descend'),k));

niter_learning = 10;
niter_dico = 50;
niter_coef = 100;
E0 = [];
X = zeros(p,m);
D = D0;
for iter = 1:niter_learning
    % --- coefficient update ----
    E = [];
    gamma = 1.6/norm(D)^2;
    for i=1:niter_coef,
        R = D*X - Y;
        E(end+1,:) = sum(R.^2);
        X = ProjX(X - gamma * D'*R, k);
    end
    E0(end+1) = norm(Y-D*X, 'fro')^2;
    % --- dictionary update ----
    E = [];
    tau = 1/norm(X*X');
    for i=1:niter_dico
        R = D*X - Y;
        E(end+1) = sum(R(:).^2);
        D = ProjC( D - tau * (D*X - Y)*X' );
    end
    E0(end+1) = norm(Y-D*X, 'fro')^2;
end
%%
% Display the dictionary.
clf;
plot_dictionnary(D,X, [8 12]);
