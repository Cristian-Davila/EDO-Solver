# Solucionador de Ecuaciones Diferenciales de Primer Orden

Implementación en GNU Octave de un solucionador simbólico de ecuaciones diferenciales ordinarias de primer orden.

El proyecto utiliza una arquitectura modular que permite identificar automáticamente el tipo de ecuación diferencial y ejecutar el método de solución correspondiente. Cada método se encuentra implementado mediante una función independiente y los casos reducibles reutilizan los métodos principales después de realizar las transformaciones necesarias.

## Descripción

El objetivo del proyecto es identificar y resolver simbólicamente ecuaciones diferenciales ordinarias de primer orden.

El programa recibe una ecuación diferencial escrita en términos de `x`, `y`, `dx` y `dy`. A partir de su estructura, `identificador.m` determina si corresponde a alguno de los métodos implementados y prepara los parámetros necesarios para ejecutar el procedimiento de solución.

Actualmente se implementan siete tipos de ecuaciones:

* Variables separables.

* Homogéneas.

* Reducibles a homogéneas.

* Bernoulli.

* Lineales.

* Exactas.

* Reducibles a exactas.

La solución se obtiene utilizando las herramientas de cálculo simbólico proporcionadas por el paquete `symbolic` de GNU Octave.

## Arquitectura

El programa utiliza una función principal para controlar la ejecución y una función encargada de identificar la ecuación.

* `solucionador.m` — recibe la ecuación, solicita su identificación y ejecuta el método correspondiente.

* `identificador.m` — analiza la ecuación y determina qué método puede utilizarse.

Los métodos de solución se encuentran separados en funciones independientes:

* `variablesSeparables.m`

* `homogenea.m`

* `reducibleHomogenea.m`

* `linealBernoulli.m`

* `lineal.m`

* `exacta.m`

* `reducibleExacta.m`

Esta separación permite modificar o ampliar un método sin tener que modificar la estructura principal del programa.

Además, los métodos reducibles reutilizan las implementaciones existentes. Por ejemplo, una ecuación reducible a homogénea es transformada y posteriormente resuelta mediante `homogenea.m`, mientras que una ecuación reducible a exacta utiliza `exacta.m`.

### Identificación

`identificador.m` realiza una serie de validaciones para determinar la forma de la ecuación.

El proceso sigue el siguiente orden general:

```text
Ecuación de entrada
        │
        ▼
Variables separables
        │
        ▼
Homogénea
        │
        ▼
Reducible a homogénea
        │
        ▼
Lineal / Bernoulli
        │
        ▼
Exacta
        │
        ▼
Reducible a exacta
        │
        ▼
Método identificado
```

Cuando una ecuación es reconocida, además de determinar su tipo, `identificador.m` genera los parámetros que necesita la función encargada de resolverla.

De esta manera, la identificación y la resolución se mantienen separadas.

### Métodos implementados

#### Variables separables

`variablesSeparables.m` separa los términos que dependen de `x` y `y`, integra ambos lados y construye la expresión de la solución.

#### Homogéneas

`homogenea.m` utiliza una sustitución del tipo:

$$
y=ux
$$

para transformar la ecuación en una ecuación de variables separables.

#### Reducibles a homogéneas

`reducibleHomogenea.m` determina una traslación de variables que permite transformar la ecuación en una homogénea.

Después de realizar la transformación, reutiliza `homogenea.m` para obtener la solución.

#### Bernoulli

`linealBernoulli.m` identifica la potencia de `y` correspondiente a la ecuación de Bernoulli y aplica la transformación necesaria para convertirla en una ecuación lineal.

#### Lineales

`lineal.m` resuelve ecuaciones diferenciales lineales de primer orden mediante el factor integrante.

#### Exactas

`exacta.m` comprueba la condición de exactitud mediante las derivadas parciales:

$$
\frac{\partial M}{\partial y}
=
\frac{\partial N}{\partial x}
$$

y posteriormente obtiene la función potencial mediante integración.

#### Reducibles a exactas

`reducibleExacta.m` analiza la ecuación en busca de un factor integrante de las formas contempladas por el programa.

Una vez obtenido el factor integrante, transforma la ecuación y reutiliza `exacta.m` para obtener la solución.

## Ejemplos

Los siguientes ejemplos muestran diferentes partes del proceso de identificación y resolución implementado en el proyecto.

### Variables separables

Como entrada se utiliza:

```text
dy == x*y*dx
```

El programa transforma la ecuación a:

$$
\frac{dy}{y}=x\,dx
$$

y la identifica como:

```text
Variables separables
```

La solución obtenida es:

$$
\log(y)=\frac{x^2}{2}
$$

### Homogénea

Como ejemplo de una ecuación homogénea se utiliza:

```text
(2*x^2-y^2)*dx+(2*x*y+x^2)*dy==0
```

El programa identifica la ecuación como:

```text
Homogenea
```

y ejecuta `homogenea.m`.

La solución simbólica obtenida por GNU Octave es:

$$
\log(y)
=
\log\left(\frac{x}{y}\right)
-
\log\left(
\frac{2x^2}{y^2}
+
\frac{x}{y}
+
1
\right)
$$

La forma exacta de la expresión mostrada puede depender de las simplificaciones realizadas por el paquete `symbolic`.

### Reducible a homogénea

Para demostrar la identificación y transformación de una ecuación reducible a homogénea se utiliza:

```text
(x+y+1)*dx+(2*x+3*y+4)*dy==0
```

El programa identifica la ecuación como:

```text
Reducible a homogenea
```

La función `reducibleHomogenea.m` determina la transformación necesaria y posteriormente utiliza `homogenea.m` para resolver la ecuación transformada.

La solución simbólica obtenida es:

$$
\log(y+2)
=
-\frac{
\log\left(
\frac{(x-1)^2}{(y+2)^2}
+
\frac{3(x-1)}{y+2}
+
3
\right)
}{2}
+
\frac{2\sqrt{3}}{3}
\arctan\left(
\frac{2\sqrt{3}(x-1)}
{3(y+2)}
+
\sqrt{3}
\right)
$$

Este ejemplo muestra la reutilización de `homogenea.m` desde un método diferente.

### Reducible a exacta

Para una ecuación reducible a exacta se utiliza:

```text
(x+y)*dx+(x+x^2/2+x*y)*dy==0
```

El programa identifica la ecuación como:

```text
Reducible a exacta
```

`reducibleExacta.m` determina un factor integrante y transforma la ecuación antes de utilizar `exacta.m`.

La solución simbólica obtenida es:

$$
x^2e^y+2xye^y=c
$$

Este ejemplo demuestra la reutilización de `exacta.m` después de aplicar el factor integrante.

## Entrada de ecuaciones

Las ecuaciones se introducen utilizando la sintaxis de GNU Octave y las variables simbólicas:

```text
x
y
dx
dy
```

Por ejemplo:

```text
(2*x^2-y^2)*dx+(2*x*y+x^2)*dy==0
```

La igualdad debe utilizar `==`, de acuerdo con la sintaxis utilizada por GNU Octave.

Actualmente, la entrada debe utilizar la sintaxis reconocida por Octave y el paquete `symbolic`. Por ejemplo, un producto entre un número y una variable debe escribirse como `2*x` en lugar de `2x`.

El programa recibe la expresión, identifica el tipo de ecuación y ejecuta el método correspondiente.

## Estructura del proyecto

```text
EDOL/
│
├── exacta.m
├── homogenea.m
├── identificador.m
├── lineal.m
├── linealBernoulli.m
├── reducibleExacta.m
├── reducibleHomogenea.m
├── solucionador.m
├── variablesSeparables.m
├── .gitignore
├── .gitattributes
└── README.md
```

Los archivos `.m` contienen las funciones encargadas de identificar y resolver las ecuaciones diferenciales.

`solucionador.m` funciona como punto de entrada del programa, mientras que `identificador.m` se encarga de seleccionar el método correspondiente.

El archivo `.gitignore` se incluye como parte de la estructura del repositorio, aunque el proyecto actualmente no requiere excluir archivos generados o auxiliares.

## Tecnologías

* GNU Octave.

* Paquete `symbolic`.

* Cálculo simbólico.

* Ecuaciones diferenciales ordinarias.

## Entorno de ejecución

El proyecto fue desarrollado para ejecutarse mediante **GNU Octave** utilizando el paquete **`symbolic`**, el cual es necesario para realizar las operaciones de cálculo simbólico utilizadas por los diferentes métodos.

### Requisitos
GNU Octave.
Paquete symbolic para GNU Octave.

El paquete symbolic debe estar instalado antes de utilizar el programa.

Para instalarlo desde GNU Octave:

```octave
pkg install -forge symbolic
```

La instalación solamente es necesaria una vez.

Una vez instalado el paquete, coloque los archivos del proyecto en la misma carpeta y ejecute:

```octave
solucionador
```

El programa carga automáticamente el paquete symbolic, por lo que no es necesario ejecutar manualmente:

```octave
pkg load symbolic
```

cada vez que se inicia el solucionador.

## Limitaciones

El proyecto está enfocado en ecuaciones diferenciales ordinarias de primer orden y actualmente reconoce únicamente los siete tipos de ecuaciones implementados.

La identificación depende de las formas matemáticas contempladas en `identificador.m`, por lo que una ecuación que pueda resolverse mediante un método conocido matemáticamente no necesariamente será reconocida si no corresponde a una de las formas implementadas.

La entrada también debe seguir la sintaxis aceptada por GNU Octave y el paquete `symbolic`.

De igual manera, la obtención de las soluciones depende de las capacidades de manipulación e integración simbólica disponibles en el paquete `symbolic`.

## Estado del proyecto

Proyecto funcional.

La versión actual cuenta con:

* Identificación automática de siete tipos de ecuaciones diferenciales.

* Implementación independiente de cada método.

* Reutilización de métodos para ecuaciones reducibles.

* Resolución simbólica mediante GNU Octave.

* Ejecución completamente desde consola.

Como posibles mejoras futuras se contempla:

* Ampliar la cantidad de métodos de solución para cubrir ecuaciones diferenciales ordinarias de orden superior.

* Implementar una etapa de procesamiento de entrada que permita utilizar una notación matemática más natural antes de enviarla al paquete `symbolic`. Por ejemplo, transformar expresiones como `2x` a la sintaxis `2*x` requerida por Octave.

* Ampliar la salida del programa para mostrar de forma más detallada el procedimiento simbólico utilizado durante la resolución, además de mostrar únicamente la expresión final.

## Autor

**Cristian Samuel Dávila Gómez**

Ingeniero en Sistemas Computacionales.
