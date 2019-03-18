# Hypernova

Indice

 1. Introducción
 2. Historia
 3. Personajes
 4. Modo de juego
 5. Requerimientos
 6. Planeacion
 7. Distribución del trabajo
 8. Conclusiones finales

## 1. Introducción

Este sera un proyecto en el cual se aplicara toda la tecnología conocida en el momento actual , en la cuales se encuentran:

 1. Programación Lua
 2. Motor de Fisica
 3. Sonidos
 4. Graficas
 5. Shaders
 6. Game design
 7. Tiled
 8. Redes
 9. Servidor
 10. Webservices

Lo que se va a realizar es un juego multijugador de 6 personas, en los cuales estos tendrán una batalla campal en distintos mapas mientras enemigos aleatorios intentaran eliminar a cualquiera de ellos, el juego sera de vista superior y contara con una clave de seguridad para ingresar al servidor de nuestro juego, se prevee que el juego pueda correr tanto en pc como en android y html5 (opcional).

## 2. Historia

Esta viene de otro juego que tenia pensado, pero por razones de tiempo seria un costo muy grande desarrollarlo, pero como la mecánica se adapta a un juego de disparos, puede ser aplicado para un juego simple. En el inicio del juego los personajes tendrán un breve dialogo y la batalla comenzará, el superviviente de esa ronda sera el ganador.

## 3. Personajes

Son un total de 6 personajes, los cuales se dividen en:

### Aegis

<!--- Insertar imagen -->

#### Comportamiento

Esta preparado para todo, solo quiere quitarse todo ese peso de encima. Calculador en la mayoria de cosas, ademas de improvisar sus ataques. Tiene afecto a los que lo siguen, aunque cree que el mundo ya esta roto. Siente remordimiento por los que murieron en sus fracasos.

Vive en la zona media de la ciudad

#### Diseño

Utiliza una capa de color ploma/gris, una mascara de proteccion negra con interfaz roja, botas marrones y un chaleco de proteccion plomo.

Utiliza una pistola de color azul/negra y roja/negra

#### Armas

* Pistola de habilidad hielo-fuego
	* Hielo crea un escudo
	* Fuego genera un daño en una figura circular, daño medio.
*  Escudo Magnético 
	* Genera un escudo magnético para defenderse
* Armadura Plas-l5
	* Armadura creada para resistir golpes mortales
* A su máximo poder puede transformarse en otra forma de vida.


### Solange

<!--- Insertar imagen -->

### Comportamiento

De caracter dulce, es muy decidida y sabe encontrar el lado bueno de las personas, no le gusta utilizar armas y solo lo hace para defender a los demas, es empatica y amigable.

Vive en la zona rural a las afueras de la ciudad, pero se muda temporalmente a la ciudad.

Tiene un hermano que se volvio mitad planta.

#### Diseño

Utiliza un abrigo de invierno color gris y blanco, jeans gris, unas botas grises.

Utiliza una pistola de color negro con amarillo

#### Armas

* Pistola de habilidad electricidad.
	* Electricidad genera un porcentaje de parálisis, ademas del daño. Daño bajo.
* Escudo de plasma
	* Puede usar un escudo de plasma para defenderse, ademas de generar un daño menor
*  Armadura Plas-T1
	* Armadura creada para generar mayor movilidad y recibir la mayoría de golpes.
* A su máximo poder puede convocar un androide para que pelee en su lugar.

### Xeon

<!--- Insertar imagen -->

#### Comportamiento

Es un moustruo que tiene un odio hacia los humanos, ya que fue creados por estos como un experimento para crear una quimera. Cree estar en la cima de la evolucion y solo sigue ordenes de alguien mas fuerte que el. Le gusta las grandes luchas.

Fue creado en el laboratorio del area secreta, cerca a la ciudad.

#### Diseño

Es un ser sin vestimenta, sin genero y de color mostaza/piel.

#### Armas

* Agujas
	* Agujas hechas de material orgánico, capaz de atravesar el acero, hace un daño medio.
* Golpes
	* Golpes con un rango medio de alcance. Hace daño medio.
* Armadura de carne
	* Su cuerpo es una masa de carne muy resistente, capaz de aguantar golpes de gran poder.
* Escudo orgánico
	* Escudo capaz de repeler varios ataques y ademas servir para el ataque.
* A su máximo poder se transforma en una bestia irregular.

### Radian

<!--- Insertar imagen -->

#### Comportamiento

Es el ultimo rey de su raza, conocidos como immortales, es de los mas fuertes del universo e intenta restaurar a cualquier costo el imperio de su familia. Ve a los humanos como seres carentes de empatia y autodestructivos.

Tiene un caracter muy deductivo y pensativo, tiene habilidades como telepatia y es el que controla todo desde las sombras.

Nacio en el planeta de los immortales, antes del choque de meteoros en la batalla contra Dios.

#### Diseño

Utiliza una armadura de color dorado con blanco, con varias gemas incrustadas, ademas de una capa azul.

Utiliza una pistola verde y negro, junto a una espada de color verde/azul y mango color dorado.

#### Armas

* Plasma
	* Plasma cargado capaz de causar un daño enorme. Gran daño
* Espada
	* Espada capaz de realizar un gran daño, ademas de destruir los ataques, pero muy lento. Gran daño
* Armadura nova 
	* La mejor armadura del universo, generado con material de estrellas.
* A su máximo poder la armadura genera una ráfaga de luz muy potente.

### Mr horror & Mrs sorrow

<!--- Insertar imagen -->

#### Comportamiento

Fueron cientificos que pudieron controlar el ectoplasma de manera eficiente, son muy confiados e inteligentes.

Son de la ciudad, pero viven en la casa maldita.

#### Diseño

Utilizan unos trajes de la era victoriana, ademas de un sombrero. Todo de color negro
Utilizan unas pistolas de color verde oscuro con negro.

#### Armas

* Pistolas fantasmas
	* Pistolas que lanzan ectoplasma, hace daño bajo.
* Escudo de ectoplasma
	* Escudo capaz de hacer invisible al usuario.
* Armadura fantasma
	* Armadura generada para una mayor velocidad, capaz de recibir pocos daños.
* Puede alternar entre los personajes.

### Cromwell

<!--- Insertar imagen -->

#### Comportamiento

Es un soldado transformado en arma, al serle implantado celulas vegetales, es muy recto y sigue las ordenes que le dan.

Vivia en las afueras de la ciudad en un pueblo con sus hermanos, pero se muda a la ciudad .

#### Diseño

Tiene caracteristicas de una planta, tiene el cuerpo de color verde y marron

#### Armas

* Balas semillas
	* Balas de semillas orgánicas generadas por el individuo, Daño bajo
* Espada plantae
	* Plantas que salen como agujas del suelo, hacen daño alto
* Armadura natura
	* Armadura generada por un cuerpo de vida hecho de plantas, capaz de recibir gran cantidad de daño
* A su máximo poder el usuario reúne energía solar de la fotosíntesis para dañar a sus enemigos.

## Modo de juego

El usuario estará en un mapa generado, en el cual este tendrá que luchar contra los demás jugadores, ademas de los enemigos que albergara el mapa. A su vez el usuario cuenta con 2 barras, una que sera la vida y otra el medidor de daño, 

### Medidor de daño.
En un estado normal, el usuario tendrá el medidor de daño en 0, a medida que reciba daño este aumentara. La cantidad de daño puede ser disminuida al dejar de ser dañado por un tiempo. A medida de aumente el daño, las defensas irán bajando y se quitara mas vida por daño consecutivo. Por ejemplo:

```python
Daño=20
Vida=100

Medidor=0.3

Vida=Vida-(Daño+Daño*Medidor)
```

### Robot de ayuda
Sera un objeto coleccionable, que se podra encontrar en los mapas, estos ayudaran  en la batalla, lanzando un laser a los enemigos mas cercanos, se puede tener un maximo de 3 robot normales y 1 especial, este puede a su vez lanzar una rafaga mas fuerte.

* Robot de ayuda normal
	* Lanza un disparo de láser
	* Gira en torno al jugador
	* Es de color plateado
	* Puedes tener un máximo de 3

<!--- Todavia por definir-->

* Robot de ayuda especial
	* Lanza un disparo de plasma
	* Gira en torno al jugador
	* Es de color dorado
	* Puedes tener solo 1.

<!--- Todavia por definir-->

### Enemigos
Los enemigos en el juego serán de respawn aleatorios, básicamente estarán en el mapa y atacaran en grupo a los jugadores que vean mas cerca o estén frente a su rango de visión.

## Requerimientos

* Se necesitará tener un servidor global en una maquina Linux (aun falta elegir la distribución).
* Se usará el Framework Love2d
* Se usará el lenguaje de programación Lua
* Se usará Tiled para la generación de mapas
* Se usará assets creados para el juego, si se encuentran en paginas libres se pueden utilizar.
* Se usará redes para crear un juego multiplayer, pero **primero se creara una versión 1 player**.
* Se tiene un plazo de 6 meses para terminar el juego.

## Planeacion

Se requiere que se avance según el siguiente modelo.
1. Mes 1 : Creación de los assets.		
2. Mes 2 : Creación del mapa y el entorno de trabajo.	A medias	
3. Mes 3 : Pulir físicas y personajes.		A medias
4. Mes 4 : Generar el cliente y servidor.		x
5. Mes 5 : Pasar a producción el servidor.
6. Mes 6 : Levantar en servidor real.

## Distribución

Yo haré el trabajo, si se encuentra alguien mas se distribuirá el trabajo 

## Conclusiones

<!--- Todavia por definir-->
