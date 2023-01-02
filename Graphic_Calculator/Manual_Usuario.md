# Manual Usuario
<p>Practica 2<br>
Arquitectura de Computadores y Ensambladores 1</p>

---

### Grupo 10

---

Integrantes

|   Carnet  |      Nombre   |
|-----------|---------------|
| 201504464 | Herberth Abisai Avila Ruiz |

# Graphic Calculator

<p>Consiste en una calculadora gráfica. Ingresar una funcion para luego poder derivarla e integrarla.
La calculadora resuelve ecuaciones de grado n (donde n es un número entero no mayor a 5) y las muestra.</p>

# Guia/Tutorial

## 1. Pantalla de inicio Aplicación

<p>Es la primera pantalla que se le muestra al usuario, le permite ingresar la funcion que quiere resolver.<br>
Contiene una lista de opciones para ejecutarse segun lo que indica.</p>

![pantalla](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/menu.png)

## 2. Seleccionar Opcion 1 (Ingresar Ecuacion)

<p>Se muestra tal como esta dibujada en la siguiente imagen. Aca permitira ingresar la funcion.</p>

![IngresarFuncion](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion1.png)

<p>Si la funcion es correcta mostrara un mensaje de alerta. Presionar ENTER para continuar.</p>

![FuncionIngresada](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion1(1).png)

## 3. Seleccionar Opcion 2 (Imprimir la funcion almacenada)

<p>Imprime una lista de 20 funciones que son permitidas almacenar, si en alguna posicion no ha sido almacenada ninguna funcion se muestra como Espacio libre.</p>

![MostrarFuncion](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion2.png)

## 4. Seleccionar Opcion 3 (Imprimir la derivada)

<p>Para ello se ingresa un ID de la funcion que quiere mostrar su derivada. El Id esta entre las letras mayusculas A-T<br>
Puede consultar el ID de la funcion a operar Seleccionando la Opcion 2 (Imprimir la funcion almacenada).</p>

![Derivada_ID](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion3.png)

<p>Ya ingresado el ID se mostrara la funcion junto a su derivada.</p>

![Derivada](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion3(1).png)

## 5. Seleccionar Opcion 4 (Imprimir la integral)

<p>Para ello se ingresa un ID de la funcion que quiere mostrar su integral. El Id esta entre las letras mayusculas A-T<br>
Puede consultar el ID de la funcion a operar Seleccionando la Opcion 2 (Imprimir la funcion almacenada).</p>

![Integral_ID](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion4.png)

<p>Ya ingresado el ID se mostrara la funcion junto a su integral.</p>

![Integral](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion4(1).png)

## 6. Seleccionar Opcion 5 (Graficar la funcion)
<p>Permite graficar la funcion ingresada hasta de grado 4, de coeficientes de 1 solo digito. Pudiendo tambien graficar de la misma su derivada.</p>
<p>Para ello se ingresa un ID de la funcion que quiere mostrar la grafica. EL Id esta entre las letras mayusculas A-T<br>
Pude consultar el ID de la funcion a operar Seleccionando la Opcion 2 (Imprimir la funcion almacenada).</p>

![Grafica_ID](/Images/ChooseOpt5.png)

<p>Ya ingresado el ID se mostrara un sub-menu en donde se puede seleccionar la funcion normal o la derivada para graficar.<br>
La grafica de la integral no fue implementada!!!<br>
La opcion Regresar, retorna al menu principal.</p>

![Menu_Graph](/Images/ChooseGraph.png)

<p>Se pide que se ingresen los intervalos para mostrar la grafica. Puede ser desde -99 a 99</p>

![Intervalo](/Images/Intervalo.png)

<p>Ya comprendido como funciona la opcion 5; si se ha ingresado una funcion de grado 4:</p>

![FuncX4](/Images/funcx4.png)

<p>La grafica para una funcion grado 4 se mostraria asi:</p>

![GraphX4](/Images/Graphx4.png)

<p>La derivada de la funcion grado 4 se mostraria asi:</p>

![DerX4](/Images/DerX4Grapx3.png)

<p>Si se ha ingresado una funcion de grado 3:</p>

![FuncX3](/Images/funcx3.png)

<p>La grafica para una funcion grado 3 se mostraria asi:</p>

![GraphX3](/Images/DerX4Grapx3.png)

<p>La derivada de la funcion grado 3 se mostraria asi:</p>

![DerX3](/Images/DerX3Graphx2.png)

<p>Si se ha ingresado una funcion de grado 2:</p>

![FuncX2](/Images/funcx2.png)

<p>La grafica para una funcion grado 2 se mostraria asi:</p>

![GraphX2](/Images/DerX3Graphx2.png)

<p>La derivada de la funcion grado 2 no se ha podido implementar!</p>

<p>Si se ha ingresado una funcion de grado 1:</p>

![FuncX1](/Images/funcx1.png)

<p>La grafica para una funcion grado 1 se mostraria asi:</p>

![GraphX1](/Images/Graphx1.png)

<p>La derivada de la funcion grado 1 se mostraria asi:</p>

![DerX1](/Images/DerX1.png)

<p>Si se ha ingresado una funcion de grado 0 (constante):</p>

![FuncX0](/Images/funcx0.png)

<p>La grafica para una funcion grado 0 (constante) se mostraria asi:</p>

![GraphX0](/Images/Graphx0.png)

<p>La derivada de la funcion grado 0 se mostraria asi:</p>

![DerX0](/Images/DerX0.png)

## 7. Seleccionar Opcion 6, 7 (Encontrar ceros por Newton, Encontrar ceros por Steffensen)
<p>Opciones no implementadas aun.</p>

## 8. Seleccionar Opcion 8 (Salir de la aplicacion)

<p>Permite la terminacion de la aplicacion</p>

![Salir](https://github.com/Herberth3/-ACYE1-P2_201504464/blob/main/Graphic_Calculator/Images/Opcion8.png)

