function [tipo, funcion, entrada] = identificador(f)
  syms x y dx dy;
  validado = false;

  expr = factor(solve(f, dy)/dx);
  if !has(expr, dx)
    #validación para variables separables
    exprx = sym(1);
    expry = sym(1);
    syms z;
    terminos = children(factor(expr)*z);
    variables = true;
    for i = 1:length(terminos)
      term = terminos(i);
      if has(term, x) && !has(term, y)
        exprx = exprx * term;
      elseif has(term, y) && !has(term, x)
        expry = expry / term;
      elseif has(term, y) && has(term, x)
        variables = false;
        break;
      elseif !has(term, z)
        exprx = exprx * term;
      endif
    endfor
    if variables
      tipo = 'Variables separables';
      funcion = expry*dy == exprx*dx;
      entrada = exprx/expry;
      validado = true;
    endif

    #validación para homogenea
    M(x, y) = sym(1);
    N(x, y) = sym(1);
    if !validado
      constante = sym(1);
      for i = 1:length(terminos)
        term = terminos(i);
        if !has(term, x) && !has(term, y) && !has(term, z)
          constante = constante*term;
        elseif !has(term, z)
          [num, den] = numden(term);
          if num == 1
              N(x, y) = N(x, y) * term^-1;
          else
            M(x, y) = M(x, y) * term;
          endif
        endif
      endfor
      M(x, y) = M(x, y)*constante*(-1);
      syms t;
      try
        [homogM, t_M] = coeffs(factor(M(t*x, t*y), t), t);
        [homogN, t_N] = coeffs(factor(N(t*x, t*y), t), t);
        if length(homogM) == 1 && length(homogN) == 1 && t_M == t_N
          validado = true;
          funcion = M * dx + N * dy == 0;
          tipo = 'Homogenea';
          entrada = [M, N];
        endif
      end_try_catch

    endif

    #validación para reducible a homogenea
    if !validado
      M = expand(M);
      N = expand(N);
      terminosM = children(M);
      terminosN = children(N);
      xi(1) = sym(0);
      xi(2) = sym(0);
      yi(1) = sym(0);
      yi(2) = sym(0);
      esReducibleHomogenea = true;
      for i = 1:length(terminosM)
        term = terminosM(i);
        if has(term, x) && !has(term, y)
          try
            if degree(term, x) == 1
              xi(1) = coeffs(term, x);
            else
              esReducibleHomogenea = false;
              break;
            endif
          catch
            esReducibleHomogenea = false;
            break;
          end_try_catch
        elseif has(term, y) && !has(term, x)
          if degree(term, y) == 1
            yi(1) = coeffs(term, y);
          else
            esReducibleHomogenea = false;
            break;
          endif
        elseif has(term, y) && has(term, x)
          esReducibleHomogenea = false;
          break;
        endif
      endfor

      if esReducibleHomogenea
        for i = 1:length(terminosN)
          term = terminosN(i);
          if has(term, x) && !has(term, y)
            if degree(term, x) == 1
              xi(2) = coeffs(term, x);
            else
              esReducibleHomogenea = false;
              break;
            endif
          elseif has(term, y) && !has(term, x)
            if degree(term, y) == 1
              yi(2) = coeffs(term, y);
            else
              esReducibleHomogenea = false;
              break;
            endif
          elseif has(term, y) && has(term, x)
            esReducibleHomogenea = false;
            break;
          endif
        endfor
      endif
      if esReducibleHomogenea && xi(1)*yi(2)!=xi(2)*yi(1)
        tipo = 'Reducible a homogenea';
        funcion = M * dx + N * dy == 0;
        entrada = [M, N];
        validado = true;
      endif
    endif

    #lineal y bernoulli
    if !validado
      try
        [coeficientes, ys] = coeffs(expand(expr), y);
        if length(ys) == 2
          lineal = false;
          bernoulli = false;
          n = 0;
          j = 0;
          for i = 1:2
            potencia = degree(ys(i), y);
            if potencia == 1 && !lineal
              lineal = true;
            elseif potencia == 1 && lineal
              bernoulli = true;
              n = 1;
              j = i;
            elseif potencia != 0
              bernoulli = true;
              n = potencia;
              j = i;
            endif
          endfor
          if lineal && bernoulli
            validado = true;
            funcion = dy/dx + coeficientes(1)*ys(1) == coeficientes(2)*ys(2);
            k = 0;
            if j == 1
              k = 2;
            else
              k = 1;
            endif
            entrada = [-coeficientes(k), coeficientes(j), n];
            tipo = 'Bernoulli';
          elseif lineal
            validado = true;
            funcion = dy/dx + coeficientes(1)*ys(1) == coeficientes(2);
            entrada = [-coeficientes(1), coeficientes(2)];
            tipo = 'Lineal';
          endif
        endif
      end_try_catch
    endif

    #exacta y reducible
    if !validado
      My = diff(M, y);
      Nx = diff(N, x);
      if My == Nx
        validado = true;
        funcion = M*dx + N*dy == 0;
        entrada = [M, N];
        tipo = 'Exacta';
      else
        if !has(simplify((My-Nx)/N), y) || !has(simplify((Nx-My)/M), x)
          validado = true;
          funcion = M*dx + N*dy == 0;
          entrada = [M, N];
          tipo = 'Reducible a exacta';
        endif
      endif
    endif

    if !validado
      tipo = 'Error';
    endif
  else
    tipo = 'Error';
  endif

endfunction
