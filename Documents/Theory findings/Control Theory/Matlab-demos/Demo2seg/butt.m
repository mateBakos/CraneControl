figure(2);clf
C=[1 1 0 0];
G=ss(A,B1,C,zeros(size(C,1),size(B1,2)));
z=zero(G);
z(2)=-z(2);
p=eig(A);
p(1:2)=-conj(p(1:2));
for rho=logspace(-10,10,200);
    [Fl,P,E]=lqr(A,B1,C'*C,rho);
    plot(real(E(1:2)),imag(E(1:2)),'r.');
    plot(real(E(3:4)),imag(E(3:4)),'b.');hold on;
end;
plot(real(z),imag(z),'g*');hold on;
plot(real(p),imag(p),'m*');hold on;
grid on;axis('equal')
axis(axis/10)
epdfdelft('fig1bw')
