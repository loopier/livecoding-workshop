// INTRO AL LIVE CODING CON SUPERCOLLIDER
// 09/10-02-2022
// Roger Pibernat basado en código de SHELLY KNOTTS

// LIVE CODING ------------------------------------------------------//
// https://toplap.org/wiki/ManifestoDraft

// HOLA ------------------------------------------------------//
// para evaluar una línea de código, pon el cursor en
// la línea y presiona SHIFT+RETURN simultáneamente
i

// imprimir texto en el post window
"kaixo jendea".postln;

// en el post window sale la información de lo que está pasando

// prueba de cambiar el texto "kaixo jendea" y ejecútalo

// cualquier cosa después de "//" es un COMENTARIO.
// Es útil para poner notas leíbles para humanos, y recordatorios.
// También es útil para decirle a SuperCollider que ignore una parte del código.

// EN MARCHA ------------------------------------------------------//
// SuperCollider consta de dos partes: el servidor (scserver) y el lenguaje (sclang).
// Si queremos hacer ruido hay que poner en marcha el servidor evaluando
// la siguiente línea
s.boot;
// también se puede poner en marcha con CTRL+B o desde el menú Language > Boot Server

// con la siguiente línea, harás tu primer sonido
().play;

// para parar el servidor evalúa (debes vovler a ponerlo en marcha si quieres
// hacer más sonido)
s.quit;

// SEGURIDAD ------------------------------------------------------//
// el control más importante de SuperCollider es CTRL+. (o CMD+.)!!!

// y la norma MÁS IMPORTANTE cuando usemos supercollider es:
// NUNCA, NUNCA, NUNCA evaluar código con los auriculares puestos.

// LIVE CODING ------------------------------------------------------//
// para hacer live coding en supercollider, necesitamos primero esta línea.
// Luego veremos qué hace.
p = ProxySpace.push;

().play; // vuelve a hacer un sonido

// cuando queremos hacer un sonido, normalmente usamos el MÉTODO .play.
// Igual que hicimos con .postln, .play le dice a supercollider qué hacer
// con la información que le hemos dado.
// Si no le damos información sobre lo que debe tocar, tocará el sonido
// por defecto, que es lo que acabmos de oír.

// es buena idea dar nombres a los sonidos para poder acceder a ellos más tarde
~alicia = {};
// cualquier cosa entre los corchetes ahora se llama ~alice.
// digámos a ~alicia qué es lo que debe tocar
~alicia = {SinOsc.ar};
// ahora digámosle que lo toque...
~alicia.play;
// ... y que se calle
~alicia.stop;

// para que ~alicia olvide todo lo que le hemos dicho
~alicia.clear;


// SÍNTESIS BÁSICA ------------------------------------------------------//
// SinOsc es un tipo de onda, de sonido.
// Otras formas incluen
~amelia = {Saw.ar}; ~amelia.play;
~ana = {PinkNoise.ar}; ~ana.play;
~afrodita = {Pulse.ar}; ~afrodita.play;

// podemos ver las formas de onda estáticamente con .plot
{SinOsc.ar}.plot;
{Saw.ar}.plot;
{PinkNoise.ar}.plot;
{Pulse.ar}.plot;
// o mientras tocamos con .scope
s.scope(2);
// un vumeter también es útil
s.meter;

// a ver si puedes parar el sonido de ~amelia, ~ana y ~afrodita :)



// sólo le hemos dicho a SC qué tipo de onda usar
// él se ha encargado de poner valores a la fecuencia (nota) y amplitud (volumen)

// para añadir nuestros propios valores, debemos pasarle ARGUMENTOS
~alicia = { SinOsc.ar(freq: 200, phase:0, mul: 0.1) };  ~alicia.play;

// también se los podemos pasar sin el nombre del agrumento, pero entonces
// no nos podemos saltar ninguno y deben estar en orden
~alicia = { SinOsc.ar(200, 0, 0.1) };  ~alicia.play;

// prueba de cambiar los números después de 'freq:' y 'mul:'
// 'mul:' significa multiplicación, o sea 'volumen'.  QUE NO SEA MAYOR QUE 1.0!!!
// de momento 'phase:' no es importante


// ENHORABUENA, YA ESTÁS HACIENDO LIVE CODING!



// TRANSICIONES ------------------------------------------------------//
// hasta ahora los sonidos cambian en el momento que evaluamos el código
// podemos decirle a SC que queremos hacer una transición más suave, un fade entre cambios
// esto se lo podemos decir para todos los instrumentos
p.fadeTime = 2; // unidad en segundos
~alicia = { SinOsc.ar(freq: 200, phase:0, mul: 0.1) };
~alicia.play;
~alicia = { SinOsc.ar(freq: 100, phase:0, mul: 0.1) };
// o para cada uno de los instrumentos
~alicia.fadeTime = 5;
~andrea.fadeTime = 0.3;
~andrea = { Saw.ar(freq: 100, phase:0, mul: 0.1) };
~andrea.play;



// MIXER ------------------------------------------------------//
// para controlar los diferentes sonidos, también podemos usar un pequeño mixer
ProxyMixer(p);
// los nuevos sonidos se irán añadiendo automáticamente
~amanda = { Pulse.ar(100, 0.5, 0.1)}; ~amanda.play;
~amanda.stop;
// ... y eliminados
~amanda.clear;

// POLIFONIA ------------------------------------------------------//
// podemos tocar más de una nota al mismo tiempo.  Para eso usamos un array []
// que no es más que una lista de elementos separados por comas
~andrea = { Saw.ar( [100,101, 102, 103], 0.1) }; ~andrea.play;
~andrea.stop;
// aquí las cosas empiezan a complicarse.
// cuando a SC le pasamos un array [] de valores, genera tantos canales como
// valores tenga el array.  Si le pasamos  'freq:[100, 200]', normalmente crearía
// un oscilador con una frecuencia de 100 Hz en el canal 1 (izquierdo) con el primer
// valor, y otro en el canal 2 (derecho) de 200 Hz con el segundo valor.
// Pero como la primera vez que creamos a ~andrea sólo tenía un valor, creó sólo
// un canal para ella.
// Esto se arreglac borrando todo lo que sabe ~andrea con:
~andrea.clear;
~andrea = { Saw.ar( [100,201], 0.1) }; ~andrea.play;
// Si el sonido tiene más de 2 notas, pero sólo tenemos 1 canal, podemos mezclarlos
~andrea = { Mix(Saw.ar( [100, 200, 400, 801], 0.1 )) };
// También podemos repartir las notas en el espectro estéreo
~andrea = { Splay.ar(Saw.ar( [100, 200, 400, 801], 0.1 )) };

// Esto es la SÍNTESIS ADITIVA!  Un palabro para decir que sumamos muchos sonidos

// SINTESIS SUBSTRACTIVA ------------------------------------------------------//
// Otro palabro que sólo significa que usamos filtros para eliminar sonidos
~filtro_bea = { RLPF.ar(Saw.ar([700,800], 0.1), 800, 0.2, 1) }; ~filtro_bea.play;
// RLPF es un tipo de filtro: Resonant Low Pass Filter, que deja pasar sólo
// las frecuencias más bajas eliminando las más altas.

// en lugar de poner todo el código junto, lo podemos desglosar
~bea = { Splay.ar(Saw.ar( [100, 200, 400, 801], 0.1)) };
~filtro = { RLPF.ar(~bea, 400, 0.2, 1) };
~filtro.play;
// otro tipo de filtro es el RHPF, que deja pasar sólo las frecuencias agudas
// eliminando las más graves
~filtro_agudo = { RHPF.ar(~bea, 400, 0.2, 1) };
~filtro_agudo.play;

// si creamos otro sonido, podemos ir cambiando el que pasamos por el filtro
~blanca = { Splay.ar(Pulse.ar( [400, 401, 402, 801], 0.1, 0.1)) };
~filtro = { RLPF.ar(~blanca, 800, 0.2, 1) };
~filtro = { RLPF.ar(~bea, 400, 0.2, 1) };



// SINTESIS DE FM/AM/PM ------------------------------------------------------//
// otro tipo de síntesis para generar sonidos más complejos es la MODULACIÓN.
// Más palabros.  Esto sólo significa que se usa una onda para cambiar otra,
// para modularla.  La forma más simple de modulación es la modulación de
// Amplitud (AM), que modula usa una onda para cambiar el volumen de otra.
(
~cate = { Pulse.ar(
	[100,200], // frecuencias
	0.5, // width (ahora no nos importa)
	SinOsc.kr(2).range(0,0.1) // amplitud entre 0 (silencio) y (0.1) en 1/2 de segundo
) }; ~cate.play;
)
// podemos usar otras formas de onda para modular
~cate = { Pulse.ar([100,200], 0.5, LFPulse.kr(2).range(0,0.1)) };
~cate = { Pulse.ar([100,200], 0.5, LFSaw.kr(2).range(0,0.1)) };
~cate = { Pulse.ar([100,200], 0.5, LFNoise1.kr(2).range(0,0.1)) };

// otro tipo de modulación es la FM (modulación de la frecuencia)
~cleo = { SinOsc.ar([50,51], 0, 4) };
~cate = { SinOsc.ar([300,310], 0, 0.1) };
~cate = { SinOsc.ar([300,310] * ~cleo, 0, 0.1) };
~cate = { SinOsc.ar([100,120], 0, 0.1) };

// EFECTOS ------------------------------------------------------//
// podemos añadir efectos a los sonidos
~cate = { SinOsc.ar([300,310] * ~cleo, 0, 0.1) * LFPulse.kr(1)};
~fx = { GVerb.ar(~cate.ar, 50, 6) };
~cate.stop; ~fx.play;
~fx = { CombC.ar(~cate, 1, 0.125)!2 };
~fx = { Decimator.ar(~cate, 44100 * 1, 2) };


// SÍNTEIS MODULAR ------------------------------------------------------//
// mezclándolo todo
~laurie = { (SinOsc.ar([440, 442] + 1000 * LFSaw.kr(10).range(1, 0.5), 0, LFSaw.kr(15).range(1, 0)) * LFSaw.kr(10).range(SinOsc.ar(1).range(1, 6), 0) ).tanh}
~laurie.play;

~filter_laurie = {  (CombC.ar(~laurie.ar, 1, LFNoise0.kr(20).range(0.01, 0.1).round(0.01)) * LFSaw.kr(3).range(0, 2)).tanh }

~filter_laurie_2 = { GVerb.ar(DFM1.ar(~filter_laurie.ar, 500, 0.99), 10, 0.4) * 2 }


// SYNTHDEFS ------------------------------------------------------//
// un synthdef es una receta para un sonido que se guarda en memoria.
// esto nos permito reusarlo para hacer sonidos similares.
// podemos darle unos PARÁMETROS que podemos cambiar luego, como frecuencia y amplitud
(
SynthDef(\snd, { |out=0,amp=0.1,sustain=0.1,freq=440|
	var snd, env;
	//sonido
	snd = SinOsc.ar(freq, 0.5pi, 3).tanh;

	// envolvente
	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;
)

// para usarlo creamos un sinte (synth) con el mismo nombre que el de la receta
x = Synth(\snd);
x = Synth(\snd, [freq:500, sustain:5]);

// PATTERNS ------------------------------------------------------//
// creamos un metrónomo
t = TempoClock.new;
t.tempo = 120/60;

// lo podemos meter en un secuenciador
(
Pdef(\pat_1,
	Pbind(
		\instrument, \snd,
		\amp, Pseq([1,0.5, 0.7, 0.6], inf),
		\dur, 0.25,
		\legato, Pseq([1, 0.1, 0.1, 0.1, 0.1, 0.1], inf),
		\degree, [0, 2] + Pseq([0,2,4, 1], inf), //degree is analagous to 'freq' but lets us use scales instead of frequencies.
		\scale, Scale.minor,
		\octave, Pseq([6,6,6,5,7], inf), //[6, 5],
		\out, [0, 1],
	)
);
)
// le decimos que empiece a sonar siguiendo el metrónomo
Pdef(\pat_1).play(t).quant_(1);
// prueba a cambiar los números en el secuenciador (pattern)

// creamos otro secuenciador
(
Pdef(\pat_2,
	Pbind(
		\instrument, \snd,
		\amp, 1,
		\dur, Pseq([1, 0.5,0.25], inf),
		\degree, [0, 2] + Pseq([0,2,4], inf), //degree is analagous to 'freq' but lets us use scales instead of frequencies.
		\scale, Scale.minor,
		\octave, Pseq([6,6,6,5,7], inf), //[6, 5],
		\out, [0, 1],
	)
);
)
Pdef(\pat_2).play(t).quant_(1);

(
Pdef(\pattern_3,
	Pbind(
		\amp, Pwhite(0.1,0.5),
		//\instrument, \sn,
		\dur, 0.125, // Pseq([1, 0.5,0.25], inf),
		\legato, 0.1,
		\degree, [0, 2] + Prand([0,2,4,7, 1,6], 25), //degree is analagous to 'freq' but lets us use scales instead of frequencies.
		\scale, Scale.minor,
		\octave, 8, //[6, 5],
		\out, [0, 1],
	)
);
)
Pdef(\pattern_3).play(t).quant_(1);

Pdef.removeAll

// Y AHORA QUÉ? ------------------------------------------------------//
// ejemplos: /usr/share/SuperCollider/examples/
(Platform.systemAppSupportDir ++ "/examples").postln

// tutoriales (eli fieldsteel en youtube): https://www.youtube.com/playlist?list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC
// comunidad: https://scsynth.org/
// patches (synthdefs): https://sccode.org/
// mis patches (experimentales y quizás poco fiables): https://github.com/loopier/synthdefs

// sobre livecoding (toplap): https://toplap.org/wiki/Main_Page
// comunidad livecoding: https://forum.toplap.org/
// más allá  de SuperCollider: https://github.com/toplap/awesome-livecoding