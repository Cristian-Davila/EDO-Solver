function resultado = linealBernoulli(P, f, n)
  syms x y c;
  factorIntegrante = exp(int(P*(-n+1), x));
  resultado = y^(-n+1) == (int(factorIntegrante*(-n+1)*f, x)+c)/e;
endfunction
