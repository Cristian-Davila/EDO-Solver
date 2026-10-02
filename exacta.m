function resultado = exacta(M, N)
  syms x y c;
  integralM = int(M, x);
  derivadaIntegral = diff(integralM, y);
  parteH = N - derivadaIntegral;
  h = int(parteH, y);
  resultado = integralM+h==c;
endfunction
