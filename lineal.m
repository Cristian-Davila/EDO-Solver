function resultado = lineal(P, f)
  syms x y c;
  e = exp(int(P, x));
  resultado = y == (int((e*f), x))/e+c;
endfunction
