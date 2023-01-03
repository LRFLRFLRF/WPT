

clear 
syms k r1wg t2 k2w2 w1 w2 r1
A = [t2, -0.25*k2w2*r1wg;
    -0.25*k2w2*r1wg, 0.25*k2w2*w2;];

A = [t2, -0.25*k2w2*r1;
    -0.25*k2w2*r1, 0.25*k2w2;];

b = sqrtm(A)

b(1,2) = subs(b(1,2), [w2^2^0.5, r1^2], [w2, 0]);
b(1,2) = subs(b(1,2), [(k2w2^2 + 8*k2w2*t2 + 16*t2^2)^0.5, (k2w2^2 - 8*k2w2*t2 + 16*t2^2)^0.5], [k2w2+4*t2, k2w2-4*t2]);
pretty(b(1,2))




D

D = simplify(D, 'Steps', 10);
pretty(D(1,1));
pretty(D(2,2));





