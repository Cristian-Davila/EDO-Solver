function resultado = reducibleExacta(M, N)
  syms x y;
  My = diff(M, y);
  Nx = diff(N, x);
  gx(x, y) = simplify((My-Nx)/N);
  gy(x, y) = simplify((Nx-My)/M);
  mu = sym(0);
  if gx == gx(x, 1)
    mu = exp(int(gx, x));
  elseif gy == gy(1, y)
    mu = exp(int(gy, y));
  else
    print('ocurrió un error');
  endif
  M2 = M*mu;
  N2 = N*mu;
  resultado = exacta(M2, N2);
endfunction
