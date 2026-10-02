function resultado = variablesSeparables(expr)
  syms x y z;
  exprx = sym(1);
  expry = sym(1);

  terms = children(factor(expr)*z);

  for i = 1:length(terms)
    term = terms(i);
    if has(term, x) && ~has(term, y)
      exprx = exprx * term;

    elseif has(term, y) && ~has(term, x)
      expry = expry / term;

    elseif !has(term, z)
      exprx = exprx * term;
    endif
  endfor
  intx = int(exprx, x);
  inty = int(expry, y);
  resultado = inty == intx;
endfunction
