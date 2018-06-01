A=[-2 3;1 1];
P=lyap(A',eye(2))
ev=eig(A);
eig(P)
%%
A=[-2 3;1 1]-1.8*eye(2);
P=lyap(A',eye(2))
eig(P)
%%
A=[-2 3;1 1]-ev(1)*eye(2);
eig(A)
P=lyap(A',eye(2))
eig(P)
