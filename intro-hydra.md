#+TITLE: Intro Hydra

# init
Hydra fue creado por Olivia Jack inpsirada en los sintetizdores modulares de audio.
- **Hydra:** https://ojack.xyz/
- **funciones (básico):** https://ojack.xyz/hydra-functions/
- **funciones (advanced):** https://github.com/ojack/hydra/blob/main/docs/funcs.md#audio
- **hydra book:** https://hydra-book.glitch.me/#/

# controles
- `CTRL+ENTER`: evalúa una línea de código
- `CTRL+SHIFT+ENTER`: evalúa todo el código
- `ALT+ENTER`: evalúa una bloque de código
- `CTRL+SHIFT+H`: esconde o enseña el código
- `CTRL+SHIFT+F`: formatea el código usando Prettier
- `CTRL+SHIFT+S`: guarda patnallazo
- `CTRL+SHIFT+G`: comparte en twitter (@hydra_patterns)

El código funciona dentro del editor de texto integrado, o desde la consola del navegador.

# funciones básicas - generadores

Cada función es un módulo, que se encarga de hacer una sola cosa. 

Hay dos grandes grupos de módulos: **generadores (source)** y **modificadores**.

Los modificadores, a su vez, se pueden separar en: **geometría**, **color**, **mezcla (blend)** y **modulación**.

Los generadores sirven para crear una imagen, por ejemplo:

`osc()`

Si lo evaluamos, no vemos nada porque aunque el oscilador está generando señal, no está conectado a ninguna salida.  Para eso necesitamos conectarlo a un tipo especial de módulo: un módulo de salida `out()` que lo conecta al visor.

Los módulos se conectan entre sí a través de un punto, y se leen de izquierda a derecha.  Por ejemplo:

`osc().out()`

conecta la salida de `osc()` a la entrada de `out()`.  A esto lo llamamos un **patch**.

Los módulos, además de entradas y salidas tienen **parámetros** que podemos cambiar.

El oscilador `osc()` tiene 3 parámetros: 
- **frecuencia**: define el "ancho" de las oscilaciones
- **sync**: define la velocidad a la que se desplazan a través de la pantalla
- **offset**: define la distancia entre los tres valores RGB

Prueba de jugar con los valores:

`osc(50,0.3, 1).out()`

Los parámetros se pueden animar, pasando un array en lugar de un solo valor:

`shape([3,4,5]).out()`

Hydra va cambiando los valores cada cierto intervalo de tiempo, pasando secuencialmente por cada uno de los parámetros de la lista.  Para definir la velocidad a la que queremos que cambie de parámetro usamos `fast(...)` sobre el array:

`shape([3,4,5].fast(10)).out()`


Otros tipos de generadores son: `noise(5, 0.2)`, `voronoi(5,0.3,0.3)`, `shape(3,0.5,0.001)`, `gradient(10)` y `solid(1,0,0)`

Prueba a conectarlos a `out()`.  No te preocupes por el significado de los parámetros por ahora, sólo juega con ellos.

Un tipo especial de generador es `src()`.  Permite conectar una cámara a Hydra.

Lo normal sería usar `src().out()`, pero si lo pruebas verás que nada pasa.

Antes de usar la cámara, hay que inicializarla y decirle a `src()` que debe usarla: 

`s0` es el nombre de la variable en Hydra, `(0)` es el índice del `device` en el ordenador (por si tienes más de una cámara).

```
s0.initCam(0); 
src(s0).out();
```

Los sources `src()` pueden ser también vídeos:

```
s0.initVideo("https://media.giphy.com/media/AS9LIFttYzkc0/giphy.mp4");
src(s0).out();
```

imágenes:

```
s0.initImage("https://upload.wikimedia.org/wikipedia/commons/2/25/Hydra-Foto.jpg");
src(s0).out();
```

o el escritorio:

```
s0.initScreen();
src(s0).out();
```

# modificadores - geometría y color

Hasta aquí los generadores, que hacen cosas interesantes, pero más interesantes son cuando los conectamos a modificadores.

El modificador más básico es el de **geometría**, que nos permite cambiar la forma y posición de los generadores, por ejemplo, rotando:

`shape().rotate(2,1).out()`

Los  modificadores se pueden encadenar:

`shape().rotate(2,1).pixelate(20,20).out()`

La mejor manera de aprender Hydra es jugando.  Ahora que ya sabemos como conectar las funciones, en lugar de escribirlas una a una os animo a jugar con las de **geometría** y **color** que hay en esta lista con ejemplos: https://ojack.xyz/hydra-functions/. 

Probad de encadenar más de una función modificadora.

Para una lista completa de las funciones y sus parámetros: https://github.com/ojack/hydra/blob/main/docs/funcs.md#osc


# mezclando sources (blend)

Las funciones **blend** son funciones aritméticas (suma, resta, multiplicación, ...) cuyos operadores son los píxeles de cada generador. Sirven para combinar generadores mezclando sus píxeles. Como parámetros de estas funciones podemos pasar otros generadores:

```
osc().add(shape(), 0.5).out();
```

Prueba a encadenar diferentes funciones y cambiando el orden tanto de las funciones como de los sources para conseguir resultados diferentes.

# outputs

Hydra tiene 4 outputs (`o0`, `o1`, `o2`, `o3`) que se pueden usar como salida de cualquier patch con el parámetro de la función `out()`.  Si no ponemos nada, el output por defecto es `o0`. 

`osc().out()` es lo mismo que `osc().out(o0)`.

Si tenemos dos patches conectados a diferentes outputs, podemos alternar entre ellos con la función `render(...)`:

```
shape().out(o0);
osc().out(o1);
render(o0); // prueba cambiando entre `o0` y `o1`
```

Para ver los 4 outputs a la vez:

`render()`

# feedback

Un recurso muy interesante es el feedback: conectar la salida de un patch a su propia entrada.

Lo hacemos pasando un output como parámetro de un source con `src(o0)`.

```
osc().rotate(0.1,0.1).diff(src(o0).rotate(0.1,0.11),1,1.5).out(o0);
```

# modulate

La función `modulate()` usa el valor del color `r` y `g` de los píxeles del modulador como valor para desplazar los píxeles del generador en los ejes `x` e `y`.

```
osc(40,0.1,1).out(o1); // modulador
shape().modulate(o1).out(o0);
```

# audio

Podemos usar el audio para modular los parámetros de las funciones. Lo hacemos con `a`.

`a.show()` muestra 4 barras de ecualizador en la parte inferior derecha de la pantalla. Son los valores de sonidos graves, medios-bajos, medios-altos y agudos.  `a.hide()` lo vuelve a ocultar.

Si queremos dividir el espectro en más rangos usamos:

`a.setBins(6)`

Accedemos al valor de cada rango con `a.fft[0]`, donde `0` es el índice del rango que queremos usar, siendo `0` los más graves y el valor el último el más agudo (3 si tenemos 4 rangos).

`shape(4).scale(() => (a.fft[0]*4), () => (a.fft[3]*6)).out();`

Otras funciones de audio son:

```
a.setCutoff(4); \\ calibra el mínimo detectado
a.setScale(2); \\ cambia el rango detectado
a.setSmooth(0.8); \\ suaviza los cambios
```
