pkg load symbolic;

clear;
clc;

syms x y dx dy;

user_input = input("Escribe tu ecuación diferencial (recuerda usar los terminos x, y, dx, dy: \n", "s");
ecuacion = eval(user_input);

[tipo, ecuacion, entrada] = identificador(ecuacion);

disp(ecuacion);
printf(tipo);
printf('\n');

switch tipo
  case 'Variables separables'
    resultado = variablesSeparables(entrada);
  case 'Homogenea'
    resultado = homogenea(entrada(1), entrada(2));
  case 'Reducible a homogenea'
    resultado = reducibleHomogenea(entrada(1), entrada(2));
  case 'Bernoulli'
    resultado = linealBernoulli(entrada(1), entrada(2), entrada(3));
  case 'Lineal'
    resultado = lineal(entrada(1), entrada(2));
  case 'Exacta'
    resultado = exacta(entrada(1), entrada(2));
  case 'Reducible a exacta'
    resultado = reducibleExacta(entrada(1), entrada(2));
  otherwise
    printf('Este programa aún no cuenta con un solucionador para su tipo de ecuación');
    return
endswitch
disp(resultado)
