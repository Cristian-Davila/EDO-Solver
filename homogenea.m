function expr = homogenea(M, N)
  syms x dx y dy u du;
  M2(u, y) = subs(M, {'x', 'y'},{u*y, y});
  N2(u, y) = subs(N, {'x', 'y'},{u*y, y});

  f(u, y, du, dy) = M2*(y*du + u*dy) + N2*dy;
  sol(u, y, dy) = solve(f==0, du);
  sol2(u, y, dy) = factor(sol, u);
  derecha(y) = sol2(u, y, 1)/sol2(u, 1, 1);
  izquierda(u) = 1/sol2(u, 1, 1);

  #integrar
  integraly(y) = int(derecha, y);
  integralu(u) = int(izquierda, u);
  integralx(x, y) = integralu(x/y);

  expr = integraly == integralx;
endfunction
