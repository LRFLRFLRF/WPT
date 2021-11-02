syms cs ls lp uc(t) is(t)


%eqn2 = 0 == (1/cs)*int(is,0,t)-uc(t);
eqn1 = ls*cs*diff(uc,t,2)+lp*cs*diff(uc,t,2)+uc(t)==0;

cond=[uc(0)==0, uc(1)==1];
uc = simplify(dsolve(eqn1,cond))

is = simplify(cs*diff(uc,t,1))

cs = 1;
ls = 1;
lp = 1;
%x = linspace(0, 2*pi, 20);
is = simplify(subs(is))
ezplot(is);