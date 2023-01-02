# Manual Técnico<a name="id1"></a>
<p>Practica 2<br>
Arquitectura de Computadores y Ensambladores 1</p>

---

### Grupo 10<a name="id2"></a>

---

Integrante

|   Carnet  |      Nombre   |
|-----------|---------------|
| 201504464 | Herberth Abisai Avila Ruiz |

# Tabla de Contenido<a name="id3"></a>

- [Manual Técnico](#id1)
    - [Grupo 10](#id2)
- [Tabla de Contenido](#id3)
- [Graphic Calculator](#id4)
- [Requerimientos](#id5)
    - [Lenguaje](#id6)
    - [Librerias](#id7)
- [Estructura del funcionamiento](#id8)
    - [DOSBox 0.74-3](#id9)
    - [Código Assembler](#id10)
        - [Segmento principal MODEL](#id11)
        - [Segmento principal STACK](#id12)
        - [Segmento principal DATA](#id13)
        - [Segmento principal CODE](#id14)
        - [Procedimientos](#id15)
        - [Macros](#id16)

# Graphic Calculator<a name="id4"></a>

<p>El proyecto consiste en la creación de una calculadora gráfica, utilizando como herramienta un 
ensamblador de x86, el coprocesador matemático e interrupciones de DOS. Este proyecto sera 
desarrollado en 2 fases, por lo cual la primera fase consta de ingresar una funcion para luego poder derivarla e integrarla.
La calculadora deberá resolver ecuaciones de grado n (donde n es un número entero no mayor a 5) 
mediante el uso métodos numéricos de Newton y Steffensen</p>

# Requerimientos<a name="id5"></a>

- DOSBox 0.74-3 (Para la ejecucion)
- Visual Studio Code
    - Versión: 1.74.2
- Microsoft Windows 10

### Lenguaje<a name="id6"></a>

- Assembler x86 MASM para archivos .asm

### Librerias<a name="id7"></a>

<p>Es necesario el uso de las librerias macros.asm (Macros).</p>

    // MACROS
    include macros.asm


# Estructura del funcionamiento<a name="id8"></a>

## DOSBox 0.74-3<a name="id9"></a>

<p>Utilizacion de la herramienta DOSBox para la compilacion del archivo main.asm y main.exe</p>

# Código Assembler<a name="id10"></a>

## Segmento principal MODEL<a name="id11"></a>
<p>El primer segmento indica el modelo de memoria que se utilizará, este depende del tamaño que tendrá el programa, las opciones son tiny, small, médium, compact, large y huge.</p>

    .model small

## Segmento principal STACK<a name="id12"></a>
<p>En este segmento se declara el tamaño de la pila que utilizará el programa en kilobytes.</p>

    .stack

## Segmento principal DATA<a name="id13"></a>
<p>En el segmento de datos se declaran variables o constantes que se utilizarán durante la ejecución del programa.</p>

~~~
.data

    ; Asignacion: nombre_var tipo valor ("," para concantenar) ("$" final de cadena)
    ; ***************** M E N U ***********************
    menu_header                db 13, 10, '__________________Men', 163, ' Proyecto 2____________________________'
    menu_opt1                  db 13, 10, '{1} Ingresar ecuaci', 162, 'n (Funci', 162, 'n)'
    menu_opt2                  db 13, 10, '{2} Imprimir la funci', 162, 'n almacenada'
    menu_opt3                  db 13, 10, '{3} Imprimir la derivada de dicha funci', 162, 'n'
    menu_opt4                  db 13, 10, '{4} Imprimir la integral de la funci', 162, 'n'
    menu_opt5                  db 13, 10, '{5} Graficar la funci', 162, 'n original, derivada o integral'
    menu_opt6                  db 13, 10, '{6} Encontrar los ceros de la funci', 162, 'n por medio del m', 130, 'todo de Newton'
    menu_opt7                  db 13, 10, '{7} Encontrar los ceros de la funci', 162, 'n por medio del m', 130, 'todo de Steffensen'
    menu_opt8                  db 13, 10, '{8} Salir de la aplicaci', 162, 'n'
    menu_opt9                  db 13, 10, '_____________________________________________________________________'
    menu_opt10                 db 13, 10, 'Ingrese opci', 162, 'n: $'
    menu_graph                 db 10, 13, '__________________Men', 163, ' Graficas____________________________'
    menu_graph1                db 10, 10, 13, '1. Graficar original f(x)'
    menu_graph2                db 10, 13, '2. Graficar derivada f(x)'
    menu_graph3                db 10, 13, '3. Graficar integral F(x)'
    menu_graph4                db 10, 13, '4. Regresar'
    menu_graph5                db 10, 13, 10, 13, 'Ingrese una opcion: ','$'

    ; Variables globales
    var_input                  db 35 dup('$')                                                                                           ; ALMACENA LO INGRESADO POR CONSOLA
    var_termino                db 10 dup('$')                                                                                           ; ALMACENA EL TÉRMINO QUE SE ESTÁ TRABANDO
    var_funcion                db 35 dup('$')                                                                                           ; ALMACENA LA FUNCION QUE SE SELECCIONO Y LA UTILIZA PARA DERIVAR O INTEGRAR
    arr_exponentes             db 15 dup('$')                                                                                           ; LIMITADO A 15 TÉRMINOS
    arr_coeficientes           db 15 dup('$')                                                                                           ; LIMITADO A 15 TÉRMINOS
    var_exp                    db 0
    var_coef                   db 0
    var16_coef                 dw 0
    var_intervaloI             db 5 dup ('$')
    var_intervaloF             db 5 dup ('$')
    coef4                      db 5 dup ('$')
    coef3                      db 5 dup ('$')
    coef2                      db 5 dup ('$')
    coef1                      db 5 dup ('$')
    coef0                      db 5 dup ('$')
    aux_coef                   db 5 dup ('$')
    c_der3                     db 2 dup (0)
    c_der2                     db 2 dup (0)
    c_der1                     db 2 dup (0)
    c_der0                     db 2 dup (0)
    alert_graph_no_implemented db 'Grafica no implementada', 13, 10, '$'
    prueba6                    db 'Opcion 6 no implementada', 13, 10, '$'
    prueba7                    db 'Opcion 7 no implementada', 13, 10, '$'
    exp4                       db 'Estoy en exponente 4', 13, 10, '$'
    exp3                       db 'Estoy en exponente 3', 13, 10, '$'
    exp2                       db 'Estoy en exponente 2', 13, 10, '$'
    exp1                       db 'Estoy en exponente 1', 13, 10, '$'
    exp0                       db 'Estoy en exponente 0', 13, 10, '$'

    ; Declaracion de funciones (Ecuaciones que se almacenaran)
    func_1                     db 35 dup('$')
    func_2                     db 35 dup('$')
    func_3                     db 35 dup('$')
    func_4                     db 35 dup('$')
    func_5                     db 35 dup('$')
    func_6                     db 35 dup('$')
    func_7                     db 35 dup('$')
    func_8                     db 35 dup('$')
    func_9                     db 35 dup('$')
    func10                     db 35 dup('$')
    func11                     db 35 dup('$')
    func12                     db 35 dup('$')
    func13                     db 35 dup('$')
    func14                     db 35 dup('$')
    func15                     db 35 dup('$')
    func16                     db 35 dup('$')
    func17                     db 35 dup('$')
    func18                     db 35 dup('$')
    func19                     db 35 dup('$')
    func20                     db 35 dup('$')

    ; Alertar o mensajes varios
    alert_press_enter          db 13, 10, 'Presiona ENTER para continuar. $'
    alert_option_not_valid     db 13, 10, 'Opcion no valida!. $'
    alert_write_funtion        db 13, 10, 'Escribe la funci', 162, 'n: $'
    alert_bad_write_funtion    db 13, 10, 'La funci', 162, 'n esta mal escrita. $'
    alert_saveSuccess_funtion  db 13, 10, 'La funci',162,'n ha sido guardada. :)$'
    alert_overflow_funtions    db 13, 10, 'No hay espacio para la funci', 162, 'n$'
    alert_incorrent_id_funtion db 13, 10, 'Id para funcion incorrecto$'
    alert_write_id_funtion     db 13, 10, 'Ingrese ID de funcion(A-T): $'
    alert_function_notFound    db 'No existe la funcion en memoria' , '$'
    alert_init_interval        db 10, 10, 13, "Intervalo inicial: ",'$'
    alert_finish_interval      db "Intervalo final: ",'$'
    funtion_id                 db 13, 10, '0: $'
    free_space_funtion         db 'Espacio libre $'
    funcion_selected           db 13, 10, 'Funcion seleccionada: $'
    show_derivada              db 13, 10, 'Derivada de la funci', 162, 'n: $'
    show_integral              db 13, 10, 'Integral de la funci', 162, 'n: $'
    signo_menos                db '-$'                                                                                                  ; Caracter menos (-)
    signo_equis                db 'x$'                                                                                                  ; Caracter equis (x)
    signo_exponencial          db '^$'                                                                                                  ; Caracter circunflejo (^) para indicar exponenciacion
    signo_mas                  db '+$'                                                                                                  ; Caracter mas (+)
    mas_c                      db '+C$'                                                                                                 ; Caracteres mas (+) y la letra (c) para finalizar la integral

    ; Banderas
    is_funtion_error           db 0                                                                                                     ; INDICA SI LA FUNCION ES CORRECTA
    is_error_termino           db 0                                                                                                     ; BANDERA PARA SABER SI EL TERMINO ESTÁ CORRECTO
    is_error_funcion           db 0                                                                                                     ; BANDERA PARA SABER SI LA FUNCIÓN ESTÁ CORRECTA
    is_numero                  db 0                                                                                                     ; BANDERA PARA SABER SI UN CARACTER ES NÚMERO
    is_exp                     db 0                                                                                                     ; BANDERA PARA SAVER SI UN CARACTER ES EXPONENTE
    is_funcion                 db 0                                                                                                     ; BANDERA PARA VER SI ESTÁ BIEN ESCRITA LA FUNCIÓN
    is_negativo                db 0                                                                                                     ; BANDERA PARA SABER SI ES NEGATIVO
~~~

## Segmento principal CODE<a name="id14"></a>
<p>El segmento de código contiene casi todo el código del programa, siendo recursos externos como macros o procedimientos la excepción.</p>

## Procedimientos<a name="id15"></a>

### MAIN
<p>Contiene el procedimiento principal, siendo este un bucle para la seleccion del menu y asi ejecutar la funcion indicada.</p>

~~~
MAIN PROC
                       mov                  ax, @data
                       mov                  ds, ax

    ; Etiqueta para crear un loop del menu
    Loop_menu:         
                       call                 CLEAR_SCREEN                        ; Limpia la consola para solo mostrar el menu
                       CONSOLE_OUT          menu_header                         ; Muestra el menu en consola
                       call                 CONSOLE_IN                          ; Capturla lo ingresado por consola
                       call                 LIMPIAR_R                           ; Actualiza los registros

                       cmp                  var_input[0], '1'                   ; Si es igual, se llama a la funcion para Ingresar Ecuacion
                       jne                  Option2                             ; Si es diferente, salta a la siguiente opcion
                       call                 FUNCTION_IN                         ; Llamada al procedimiento
                       jmp                  New_loop_menu
    Option2:           
                       cmp                  var_input[0], '2'                   ; Si es igual, se llama a la funcion para Imprimir la Ecuacion
                       jne                  Option3                             ; Si es diferente, salta a la siguiente opcion
                       call                 SHOW_FUNCTIONS                      ; Llamada al procedimiento
                       jmp                  New_loop_menu
    Option3:           
                       cmp                  var_input[0], '3'                   ; Si es igual, se llama a la funcion para Imprimir la Derivada
                       jne                  Option4                             ; Si es diferente, salta a la siguiente opcion
                       call                 DERIVAR_FUNCTION                    ; Llamada al procedimiento
                       jmp                  New_loop_menu
    Option4:           
                       cmp                  var_input[0], '4'                   ; Si es igual, se llama a la funcion para Imprimir la Integral
                       jne                  Option5                             ; Si es diferente, salta a la siguiente opcion
                       call                 FUNCTION_INTEGRAL                   ; Llamada al procedimiento
                       jmp                  New_loop_menu
    Option5:           
                       cmp                  var_input[0], '5'                   ; Si es igual, se llama a la funcion para Graficar Funcion, Derivada, Integral
                       jne                  Option6                             ; Si es diferente, salta a la siguiente opcion
                       call                 FUNCTION_GRAPH
                       jmp                  New_loop_menu
    Option6:           
                       cmp                  var_input[0], '6'                   ; Si es igual, se llama a la funcion para Encontrar ceros de la funcion por Newton
                       jne                  Option7                             ; Si es diferente, salta a la siguiente opcion
                       CONSOLE_OUT          prueba6
                       jmp                  New_loop_menu
    Option7:           
                       cmp                  var_input[0], '7'                   ; Si es igual, se llama a la funcion para Encontrar ceros de la funcion por Steffensen
                       jne                  Option8                             ; Si es diferente, salta a la siguiente opcion
                       CONSOLE_OUT          prueba7
                       jmp                  New_loop_menu
    Option8:           
                       cmp                  var_input[0], '8'                   ; Si es igual, se llama a la funcion para Salir
                       jne                  Option_not_found
                       call                 SALIR                               ; Llama al procedimiento para terminar la aplicacion

    New_loop_menu:     
                       CONSOLE_OUT          alert_press_enter                   ; Imprime peticion de presionar enter
                       call                 CONSOLE_IN                          ; Lee el salto de linea (ENTER) ingresado
                       call                 LIMPIAR_ENTRADA                     ; Vacia lo almacenado en SI
                       jmp                  Loop_menu                           ; Muestra de nuevo el menu

    Option_not_found:  
                       CONSOLE_OUT          alert_option_not_valid              ; Mostrar mensaje de opcion no valida
                       CONSOLE_OUT          alert_press_enter                   ; Imprime peticion de presionar enter
                       call                 CONSOLE_IN                          ; Lee el salto de linea (ENTER) ingresado
                       call                 LIMPIAR_ENTRADA                     ; Vacia lo almacenado en SI
                       jmp                  Loop_menu                           ; Muestra de nuevo el menu

MAIN ENDP
~~~

### CONSOLE_IN
<p>Captura la cadena ingresada por consola (caracter a caracter)</p>

~~~
CONSOLE_IN PROC
                     mov                si, offset var_input
    Loop_input:      
                     mov                ah, 1                               ;read character from standard input, with echo, result is stored in AL. If there is no character in the keyboard buffer, the function waits until any key is pressed.
                     int                21h
                     cmp                al, 13                              ;COMPARAR CON \n
                     je                 Concat_input                        ;SALTA SI LA COMPARACION ES IGUAL
                     mov                [si], al                            ;AGREGAR A MEMORIA EL DATO INGRESADO
                     inc                si                                  ;PASAR A LA SIGUIENTE CELDA
                     jmp                Loop_input                          ;FIN DEL LOOP
    Concat_input:    
                     mov                di, offset var_input
                     ret
CONSOLE_IN ENDP
~~~

### SALIR
<p>Permite la terminacion de la aplicacion</p>

~~~
SALIR PROC
                     mov                ax, 4C00H
                     int                21h
SALIR ENDP
~~~

### LIMPIAR_R
<p>Limpia los registros utilizados, poniendo a 0 los registros con el xor</p>

~~~
LIMPIAR_R PROC
                     xor                ax, ax
                     xor                bx, bx
                     xor                cx, cx
                     xor                dx, dx
                     ret
LIMPIAR_R ENDP
~~~

### LIMPIAR_ENTRADA
<p>Remueve de SI la cadena ingresada</p>

~~~
LIMPIAR_ENTRADA PROC
                     mov                si, 0
    l_ciclo:         
                     mov                var_input[si], '$'
                     inc                si
                     cmp                var_input[si], '$'
                     jne                l_ciclo
                     mov                si, 0
                     ret
LIMPIAR_ENTRADA ENDP
~~~

### FUNTION_IN
<p>Se ingresa la funcion y se hace split de los coeficientes. Valida que no este mal escrita. Guarda la funcion</p>

~~~
FUNTION_IN PROC
                     mov                is_funtion_error, 0                 ; QUITAR FLAG DE ERROR EN LA FUNCION
                     CONSOLE_OUT        alert_write_funtion                 ; MOSTRAR MENSAJE DE ESCRIBIR FUNCION
                     call               CONSOLE_IN                          ; ALMACENAR LO INGRESADO
                     SepararTerminos    var_input                           ; SEPARAR TERMINOS Y VALIDAR QUE TODO ESTE BIEN
                     cmp                is_funtion_error, 1                 ; VALIDAR SI EXISTIO ALGUN ERROR
                     je                 mostrar_error                       ; SALTAR A LA ETIQUETA QUE MUESTRA EL ERROR
                     GuardarFuncion     var_input                           ; SI TODO ESTA BIEN, SE GUARDA LA FUNCION (ECUACION)
                     CONSOLE_OUT        alert_saveSuccess_funtion           ; MOSTRAR MENSAJE DE GUARDADO EXITOSO
                     jmp                if_salir                            ; TERMINAR EL PROCEDIMIENTO DE INGRESAR FUNCION
    mostrar_error:   
                     CONSOLE_OUT        alert_bad_write_funtion
    if_salir:        
                     LimpiarVariable    var_input                           ; LIMPIA LA VARIABLE QUE ALMACENARA UNA NUEVA ENTRADA POR CONSOLA
                     ret
FUNTION_IN ENDP
~~~

### CLEAR_SCREEN
<p>Limpia todo el procedimiento mostrado en consola anterior al llamado del metodo</p>

~~~
CLEAR_SCREEN PROC
                     mov                ah, 0h                              ; Set video mode
                     mov                al, 3                               ; text mode. 80x25. 16 colors. 8 pages
                     int                10H                                 ; Interruption
                     ret
CLEAR_SCREEN ENDP
~~~

### DERIVAR_FUNTION
<p>Hace el split de la funcion seleccionada y la resuelve para mostrar la derivada</p>

~~~
DERIVAR_FUNTION proc
                     CONSOLE_OUT        alert_write_id_funtion              ; PIDE QUE SE INGRESE LA LETRA (ID) DE LA FUNCION A DERIVAR
                     call               CONSOLE_IN                          ; SE LLAMA LA FUNCION PARA LEER LO INGRESADO
                     LimpiarVariable    var_funcion                         ; SE REINICIA LA VARIABLE QUE ALMACENARA LA FUNCION SELECCINADA
                     SeleccionarFuncion var_input                           ; SE BUSCA LA FUNCION Y SE ALMACENA EN LA VARIABLE var_funcion
                     CONSOLE_OUT        funcion_select                      ; SE IMPRIME LA FUNCION SELECCIONA
                     CONSOLE_OUT        var_funcion                         ; SE IMPRIME LA FUNCION SELECCINADA

                     LimpiarVariable    arr_exponentes                      ; SE REINICIA LA VARIABLE QUE ALMACENA LOS EXPONENTES DE LA FUNCION
                     LimpiarVariable    arr_coeficientes                    ; SE REINICIA LA VARIABLE QUE CONTIENE LOS COEFICIENTE DE LA FUNCION
                     Split_Funtion      var_funcion                         ; SEPARA LA FUNCION POR COEFICIENTES Y EXPONENTES PARA ALMACENARLOS EN SU VARIABLE RESPECTIVA
                     CONSOLE_OUT        show_derivada                       ; MENSAJE PARA INDICAR LA DERIVADA ES
                     Solve_Derivation   arr_coeficientes, arr_exponentes    ; MUESTRA LA DERIVADA DE LA FUNCION
                     ret
DERIVAR_FUNTION endp
~~~

### FUNTION_INTEGRAL
<p>Hace el split de la funcion seleccionada entre coeficientes y exponentes para luego resolverla y mostrar la integral</p>

~~~
FUNTION_INTEGRAL proc
                     CONSOLE_OUT        alert_write_id_funtion              ; PIDE QUE SE INGRESE LA LETRA (ID) DE LA FUNCION A INTEGRAR
                     call               CONSOLE_IN                          ; SE LLAMA LA FUNCION PARA LEER LO INGRESADO
                     LimpiarVariable    var_funcion                         ; SE REINICIA LA VARIABLE QUE ALMACENARA LA FUNCION SELECCINADA
                     SeleccionarFuncion var_input                           ; SE BUSCA LA FUNCION Y SE ALMACENA EN LA VARIABLE var_funcion
                     CONSOLE_OUT        funcion_select                      ; SE IMPRIME LA FUNCION SELECCIONA
                     CONSOLE_OUT        var_funcion                         ; SE IMPRIME LA FUNCION SELECCINADA

                     LimpiarVariable    arr_exponentes                      ; SE REINICIA LA VARIABLE QUE ALMACENA LOS EXPONENTES DE LA FUNCION
                     LimpiarVariable    arr_coeficientes                    ; SE REINICIA LA VARIABLE QUE CONTIENE LOS COEFICIENTE DE LA FUNCION
                     Split_Funtion      var_funcion                         ; SEPARA LA FUNCION POR COEFICIENTES Y EXPONENTES PARA ALMACENARLOS EN SU VARIABLE RESPECTIVA
                     CONSOLE_OUT        show_integral                       ; MENSAJE PARA INDICAR LA INTEGRAL ES
                     Solve_Integral     arr_coeficientes, arr_exponentes    ; RESUELVE Y MUESTRA LA INTEGRAL DE LA FUNCION
                     ret
FUNTION_INTEGRAL endp
~~~

### FUNCTION_GRAPH
<p>Muestra un sub-menu para la eleccion del tipo de funcion a graficar, puede ser funcion normal, derivada o integral.<br>
Ejecuta el metodo estipulado para cada grafica.</p>

~~~
FUNCTION_GRAPH proc
                       push                 ax
                       push                 bx
                       push                 si
                       xor                  ax,ax
                       xor                  si,si

                       CONSOLE_OUT          alert_write_id_funtion
                       call                 CONSOLE_IN
                       LimpiarVariable      var_funcion
                       SeleccionarFuncion   var_input
                       CONSOLE_OUT          funcion_selected
                       CONSOLE_OUT          var_funcion
                       mov                  bl, var_funcion[0]                  ; Comparamos para que ya no se vaya a modo video
                       cmp                  bl, 36                              ; Se valida que la cadena entrante no sea un '$' antes de graficar
                       je                   l_notFound
    l_menu_graph:      
                       call                 CLEAR_SCREEN
                       CONSOLE_OUT          menu_graph
                       mov                  ah, 01h                             ;se guarda en al en código hexadecimal del caracter leído
                       int                  21h
                       cmp                  al, '1'
                       je                   l_graph_function
                       cmp                  al, '2'
                       je                   l_graph_derivative
                       cmp                  al, '3'
                       je                   l_graph_integral
                       cmp                  al, '4'
                       je                   finfin
                       CONSOLE_OUT          alert_option_not_valid
                       jmp                  finfin
    l_graph_function:  
                       call                 CLEAR_SCREEN
                       CONSOLE_IN_INTERVALS
                       call                 LIMPIAR_COEF
                       call                 INIT_COEFICIENTES
                       Split_Coeficientes   var_funcion
                       Graph_Function
                       jmp                  finfin
    l_graph_derivative:
                       call                 CLEAR_SCREEN
                       CONSOLE_IN_INTERVALS
                       call                 LIMPIAR_COEF
                       call                 INIT_COEFICIENTES
                       Split_Coeficientes   var_funcion
                       Graph_Derivative
                       jmp                  finfin
    l_graph_integral:  
                       call                 CLEAR_SCREEN
                       CONSOLE_OUT          alert_graph_no_implemented
    ;CONSOLE_IN_INTERVALS
    ;call                 INIT_COEFICIENTES
    ;Split_Coeficientes   var_funcion
    ;Graph_Integral
                       jmp                  finfin
    l_notFound:        
                       call                 FIN_VIDEO
                       ModoTexto
                       CONSOLE_OUT          alert_function_notFound
    ; terminioFunicion:

    finfin:            
                       pop                  si
                       pop                  bx
                       pop                  ax
                       ret
FUNCTION_GRAPH endp
~~~

### INIT_COEFICIENTES
<p>Inicializa las variables que ayudaran a almacenar los coeficientes que conforman la funcion, esto segun su grado.</p>

~~~
INIT_COEFICIENTES PROC
                       mov                  coef4[0], 43
                       mov                  coef3[0], 43
                       mov                  coef2[0], 43
                       mov                  coef1[0], 43
                       mov                  coef0[0], 43

                       mov                  coef4[1], 48
                       mov                  coef3[1], 48
                       mov                  coef2[1], 48
                       mov                  coef1[1], 48
                       mov                  coef0[1], 48
                       ret
INIT_COEFICIENTES ENDP
~~~

### LIMPIAR_COEF
<p>Vuelve las variables de los coeficienes a su estado normal ($$$$$$).</p>

~~~
LIMPIAR_COEF PROC
                       LimpiarVariable      coef4
                       LimpiarVariable      coef3
                       LimpiarVariable      coef2
                       LimpiarVariable      coef1
                       LimpiarVariable      coef0

                       mov                  c_der3[0], 0
                       mov                  c_der2[0], 0
                       mov                  c_der1[0], 0
                       mov                  c_der0[0], 0

                       mov                  c_der3[1], 0
                       mov                  c_der2[1], 0
                       mov                  c_der1[1], 0
                       mov                  c_der0[1], 0
                       ret
LIMPIAR_COEF ENDP
~~~

## Macros<a name="id16"></a>

### CONSOLE_OUT
<p>Permite imprimir en consola</p>

~~~
CONSOLE_OUT macro cadena
                push dx
                push ax
                mov  ah, 09h              ; output of a string at DS:DX. String must be terminated by '$'
                mov  dx, offset cadena    ; string a mostrar
                int  21h                  ; Interruption
                pop  ax
                pop  dx
endm
~~~

### ComprobarTermino
<p>Evalua que la funcion no contenga errores.</p>

~~~
ComprobarTermino macro termino
                     local       negativo,variable, numero, numero2, seguir2, exponente, error,bien, fin_ct, fin_cadena
                     push        si

                     mov         is_error_termino, 0
                     mov         si, 0

                     cmp         termino[si], '-'                                                                          ; COMPARA SI EL CARACTER ES UN MENOS
                     je          negativo                                                                                  ; SALTA SI ES UN MENOS
                     cmp         termino[si], 'x'                                                                          ; COMPARA SI EL CARACTER ES UNA VARIABLE X
                     je          variable                                                                                  ; SALTA SI ES UNA VARIABLE
                     EsNumero    termino[si]                                                                               ; COMPRUEBA SI EL CARACTER ES UN NUMERO
                     cmp         is_numero, 1                                                                              ; POR MEDIO DE LA BANDERA COMPARA SI ES UN NUMERO
                     je          numero
                     jmp         error                                                                                     ; SI EL CARACTER NO ES UN MENOS, VARIABLE X O NUMERO. ERROR

    negativo:                                                                                                              ; SI EL CARACTER ES UN MENOS
                     inc         si
                     cmp         termino[si], 'x'                                                                          ; COMPARA QUE EL SIGUIENTE CARACTER SEA UNA VARIABLE X
                     je          variable
                     EsNumero    termino[si]                                                                               ; COMPARA QUE EL SIGUIENTE CARACTER SEA UN NUMERO
                     cmp         is_numero, 1
                     je          numero
                     jmp         error                                                                                     ; SI EL SIGUIENTE CARACTER NO ES UNA VARIABLE X O UN NUMERO, ERROR
    variable:                                                                                                              ; SI EL CARACTER ES UNA VARIABLE
                     inc         si
                     cmp         termino[si], '^'                                                                          ; EL SIGUIENTE TERMINO PUEDE SER UN ^ O SIMPLEMENTE TERMINA
                     je          exponente
                     jmp         fin_ct
    exponente:                                                                                                             ; SI EL CARACTER ES UN EXPONENTE
                     inc         si
                     EsExponente termino[si]                                                                               ; SE QUE EL SIGUIENTE CARACTER SEA UN EXPONENTE (UN NUMERO)
                     cmp         is_exp, 1
                     je          fin_cadena
                     jmp         error                                                                                     ; ERROR, SI EL SIGUIENTE CARACTER NO ES UN NUMERO
    fin_cadena:      
                     inc         si
                     cmp         termino[si], '$'
                     je          fin_ct
                     jmp         error
    numero:                                                                                                                ; SI EL CARACTER ES UN NUMERO
                     inc         si
                     cmp         termino[si], 'x'                                                                          ; EL SIGUIENTE CARACTER PUEDE QUE SER UNA VARIABLE X
                     je          variable
                     EsNumero    termino[si]                                                                               ; EL SIGUIENTE CARACTER PUEDE SER OTRO NUMERO
                     cmp         is_numero,1
                     je          numero2
                     jmp         fin_cadena
    numero2:         
                     inc         si
                     cmp         termino[si], 'x'
                     je          variable
                     jmp         fin_cadena
    error:           
                     mov         is_error_termino, 1
    fin_ct:          
                     pop         si
endm
~~~

### EsExponente
<p>Comprueba que el caracter sea un numero entre 1-5</p>

~~~
EsExponente macro char
                local y, es_num, no_num, fin
                mov   is_exp, 0
    ;if char >= '0' and char <= '9'
                cmp   char, '1'
                jae   y
                jmp   no_num
    y:          
                cmp   char, '5'
                jbe   es_num
                jmp   no_num
    es_num:     
                mov   is_exp, 1
                jmp   fin
    no_num:     
                mov   is_exp, 0
    fin:        
endm
~~~

### PrintFuntion
<p>Imprime la funcion almacenada</p>

~~~
PrintFuntion macro funcion
                 local       vacio, exit
                 cmp         funcion[0], '$'       ; Valida que la cadena no este vacia
                 je          vacio                 ; Salta si la cadena esta vacia
                 CONSOLE_OUT funcion               ; Imprime la cadena de la funcion
                 jmp         exit
    vacio:       
                 CONSOLE_OUT free_space_funtion    ; Muestra que hay espacio para ingresar otra ecuacion
    exit:        
endm
~~~

### Split_Funtion
<p>Prepara la funcion en coefientes y exponentes para luego poder resolverla como derivada o integral</p>

~~~
Split_Funtion macro funcion
                  local           ciclo, seguir,seguir2, negativo, st_termino, errorxd,finxd,limpiarxd
                  push            si
                  push            di
                  push            ax

                  mov             si, 0
                  mov             di, 0
    ciclo:        
                  cmp             funcion[si], '-'
                  je              negativo
                  cmp             funcion[si], '+'
                  je              st_termino
    seguir:       
                  mov             al, funcion[si]
                  mov             var_termino[di], al                                                     ; Variable global que almacena cada caracter
                  inc             di
                  inc             si
                  cmp             funcion[si], '$'
                  jne             ciclo
                  jmp             st_termino
    negativo:     
                  cmp             var_termino[0], '$'
                  je              seguir
                  dec             si
    st_termino:   
                  cmp             var_termino[0], '0'
                  je              limpiarxd
                  LeerTermino     var_termino
    limpiarxd:    
                  LimpiarVariable var_termino
                  mov             di, 0
                  inc             si
                  cmp             funcion[si], '$'
                  jne             ciclo
    finxd:        
                  pop             ax
                  pop             di
                  pop             si
endm
~~~

### LeerTermino
<p>Termina de comprobar si el un coeficiente o un exponente para luego almacenarlo.</p>

~~~
LeerTermino macro termino
                local        negativo, variable, numero, numero2, seguir2, exponente, error,bien, fin_ct, fin_cadena,seg_var,finalizar
                push         si
                push         ax
                push         bx

                mov          is_negativo, 0
                mov          is_error_termino, 0
                mov          si, 0

                mov          var_coef, 0
                mov          var_exp, 0

                cmp          termino[si], '-'
                je           negativo
                cmp          termino[si], 'x'
                je           variable
                EsNumero     termino[si]
                cmp          is_numero, 1
                je           numero
                jmp          error

    negativo:   
                mov          is_negativo, 1
                inc          si
                cmp          termino[si], 'x'
                je           variable
                EsNumero     termino[si]
                cmp          is_numero, 1
                je           numero
                jmp          error
    variable:   
                cmp          var_coef, 0
                jne          seg_var
                mov          var_coef, 1
    seg_var:    
                inc          si
                cmp          termino[si], '^'
                je           exponente
        
                cmp          var_exp, 0
                jne          fin_ct
                mov          var_exp, 1
                jmp          fin_ct
    exponente:  
                inc          si
                mov          al, termino[si]
                sub          al, 48
                add          var_exp, al
                EsExponente  termino[si]
                cmp          is_exp, 1
                je           fin_cadena
                jmp          error
    fin_cadena: 
                inc          si
                cmp          termino[si], '$'
                je           fin_ct
                jmp          error
    numero:     
                mov          al, termino[si]
                sub          al, 48
                mov          var_coef, al
                inc          si
                cmp          termino[si], 'x'
                je           variable
                EsNumero     termino[si]
                cmp          is_numero, 1
                je           numero2
                jmp          fin_cadena
    numero2:    
    ;MULTIPLICAR *10 EL NÚMERO ANTERIOR
                mov          al, var_coef
                mov          bl, 10d
                mul          bl
                mov          var_coef, al
    ;SUMARLE EL NUEVO NUMERO
                mov          al, termino[si]
                sub          al, 48
                add          var_coef,al

                inc          si
                cmp          termino[si], 'x'
                je           variable
                cmp          termino[si], '$'
                je           fin_ct
    error:      
                mov          is_error_termino, 1
    fin_ct:     
                cmp          is_negativo, 1
                jne          finalizar
                neg          var_coef
    finalizar:  
                AgregarLista arr_exponentes, var_exp
                AgregarLista arr_coeficientes, var_coef
                pop          bx
                pop          ax
                pop          si
endm
~~~

### Solve_Derivation
<p>Resuelve la funcion para transformarla en una derivada.</p>

~~~
Solve_Derivation macro coeficientes, exponentes
                     local                  ciclo, continuar_ciclo
                     push                   si
                     push                   ax
                     push                   bx
                     mov                    si, 0
    ciclo:           
                     cmp                    exponentes[si], 0         ; IGNORAR CONSTANTES
                     je                     continuar_ciclo
    ;MULTIPLICAR EXP * COEF
                     mov                    al, coeficientes[si]
                     mov                    bl, exponentes[si]
                     imul                   bl
                     mov                    var16_coef, ax
    ;RESTAR EXP-1
                     mov                    al, exponentes[si]
                     sub                    al, 1
                     mov                    var_exp, al
                     Imprimir16ConMasyMenos var16_coef
                     cmp                    var_exp, 0
                     je                     continuar_ciclo
                     CONSOLE_OUT            signo_equis
                     CONSOLE_OUT            signo_exponencial
                     Imprimir8bits          var_exp
    continuar_ciclo: 
                     inc                    si
                     cmp                    coeficientes[si], '$'
                     jne                    ciclo
                     pop                    bx
                     pop                    ax
                     pop                    si
endm
~~~

### Solve_Integral
<p>Resuelve la funcion para transformarla en su integracion</p>

~~~
Solve_Integral macro coeficientes, exponentes
                    local                 ciclo, continuar_ciclo
                    push                  si
                    push                  ax
                    push                  bx
                    mov                   si, 0
    ciclo:          
    ;SUMAR 1 AL exp
                    mov                   al, exponentes[si]
                    add                   al, 1
                    mov                   var_exp, al
    ;DIVIDIR COEF/(EXP+1)
                    mov                   al, coeficientes[si]
                    cbw
                    mov                   bl, var_exp
                    idiv                  bl
                    mov                   var_coef, al
                    Imprimir8ConMasyMenos var_coef
                    CONSOLE_OUT           signo_equis
                    CONSOLE_OUT           signo_exponencial
                    Imprimir8bits         var_exp
    continuar_ciclo:
                    inc                   si
                    cmp                   coeficientes[si], '$'
                    jne                   ciclo
                    CONSOLE_OUT           mas_c
                    pop                   bx
                    pop                   ax
                    pop                   si
endm
~~~

### CONSOLE_IN_INTERVALS
<p>Pide que se ingresen los intervalos para mostrar la grafica. Puede ser desde -99 a 99</p>

~~~
CONSOLE_IN_INTERVALS macro
                         CONSOLE_OUT     alert_init_interval
                         Set_Entrada     var_intervaloI
                         CheckInterval   var_intervaloI
                         Convert_Inteval var_intervaloI
                         CONSOLE_OUT     alert_finish_interval
                         Set_Entrada     var_intervaloF
                         CheckInterval   var_intervaloF
                         Convert_Inteval var_intervaloF
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   SET ENTRADA
; Establece el texto ingresado por el usuario a la variable que recibe como parametro
; Param array: variable que almacenara el texto ingresado
;-----------------------------------------------------------------------------------------------------------------------------
Set_Entrada macro array
                local getCadena, finCadena
                xor   si, si
    getCadena:  
                mov   ah, 01h                 ;se guarda en al en código hexadecimal del caracter leído
                int   21h
                cmp   al, 0dh
                je    finCadena
                mov   array[si], al
                inc   si
                jmp   getCadena
    finCadena:  
                mov   al, 24h
                mov   array[si], al
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   CHECK INTERVAL
; Revisa que el intervalo sea de 2 digitos. Si el numero no trae signo le asigna el '+'.
;-----------------------------------------------------------------------------------------------------------------------------
CheckInterval macro var
                  local       order, finish
    ;Todo check if the length don't pass the limit
                  CheckLength var
                  cmp         si, 2
                  je          order
                  jmp         finish
    
    order:        
                  xor         bx, bx
                  mov         bl, var[0]
                  mov         bh, var[1]
                  mov         var[0], 43
                  mov         var[1], bl
                  mov         var[2], bh
    finish:       

endm

;-----------------------------------------------------------------------------------------------------------------------------
;   CHECK LENGTH
; Hace que SI tome la longitud que el numero ocupa en la variable
;-----------------------------------------------------------------------------------------------------------------------------
CheckLength macro var
                local while, finish
                xor   si, si
    while:      
                cmp   var[si], 24h
                je    finish
                inc   si
                jmp   while
    finish:     
endm

;-----------------------------------------------------------------------------------------------------------------------------
;    CONVERT INTERVAL
; Convierte los numeros ASCII del intervalo a un numero
;-----------------------------------------------------------------------------------------------------------------------------
Convert_Inteval macro num
                    local isNegative, finish
                    xor   ax, ax
                    xor   bx, bx
                    xor   dx, dx
                    mov   ax, 10

                    mov   bl, num[1]
                    sub   bl, 48
                    mul   bx
                    mov   dl, num[2]
                    sub   dl, 48
                    add   al, dl
                    cmp   num[0], 45
                    je    isNegative
                    jmp   finish

    isNegative:     
                    xor   ah, ah
                    neg   al
    finish:         
                    xor   cx, cx
                    mov   cl, num[0]
    ;push cx
    ;cleanBuffer num, SIZEOF num, 24h
    ;pop cx
                    mov   num[0],cl
                    mov   num[1],al
endm
~~~

### Split_Coeficientes
<p>Extrae los coeficientes de la funcion ingresada con su signo.</p>

~~~
Split_Coeficientes MACRO function
                       local           negativo, positivo, variable, numero, numero2, seguir2, exponente, error,bien, fin_ct, fin_cadena,seg_var,finalizar, inicio, l_signo
                       push            si
                       push            ax
                       push            bx

                       mov             si, 0
    inicio:            
                       mov             var_exp, 0
                       LimpiarVariable aux_coef

                       cmp             function[si], '-'
                       je              negativo
                       cmp             function[si], '+'
                       je              positivo
                       cmp             function[si], 'x'
                       je              variable
                       jmp             numero

    positivo:          
                       mov             aux_coef[0], 43
                       inc             si
                       cmp             function[si], 'x'
                       je              variable
                       jmp             numero

    negativo:          
                       mov             aux_coef[0], 45
                       inc             si
                       cmp             function[si], 'x'
                       je              variable
                       jmp             numero
    l_signo:           
                       mov             aux_coef[0], 43
    variable:          
                       cmp             aux_coef[0], 36                                                                                                                         ; Compara con '$', si existe '$' la variable no tiene asignado un signo
                       je              l_signo
                       cmp             aux_coef[1], 36                                                                                                                         ; Compara con '$', si existe '$' la variable no tiene un numero asignado                                                                                                                        ; comparar si la variable no tiene numero antes, se compara con '$' pues el caracter por defecto cuando no tiene asignado algo
                       jne             seg_var
                       mov             aux_coef[1], 49                                                                                                                         ; Si no existe un numero asignado se le asigna un '1'                                                                                                                     ; si la variable no tiene un numero antes, se le asigna un '1'
    seg_var:           
                       inc             si
                       cmp             function[si], '^'
                       je              exponente
    exponente:         
                       inc             si
                       mov             al, function[si]
                       sub             al, 48
                       add             var_exp, al
                       jmp             fin_cadena
    fin_cadena:        
                       inc             si
                       SetCoeficientes var_exp
                       cmp             function[si], '$'
                       je              finalizar
                       jmp             inicio
    numero:            
                       mov             al, function[si]
                       mov             aux_coef[1], al
                       inc             si
                       cmp             function[si], 'x'
                       je              variable
    finalizar:         
                       pop             bx
                       pop             ax
                       pop             si
ENDM

;-----------------------------------------------------------------------------------------------------------------------------------------------------------
;   Asigna cada coeficiente extraido a una de las 5 variables que necesito para graficar
;-----------------------------------------------------------------------------------------------------------------------------------------------------------
SetCoeficientes MACRO exponente
                    local  coeficiente4, coeficiente3, coeficiente2, coeficiente1, coeficiente0, finish
                    push   bx
                    xor    cx, cx
                    mov    cl, exponente

                    cmp    cl, 4
                    je     coeficiente4
                    cmp    cl, 3
                    je     coeficiente3
                    cmp    cl, 2
                    je     coeficiente2
                    cmp    cl, 1
                    je     coeficiente1
                    cmp    cl, 0
                    je     coeficiente0

    coeficiente4:   
                    Copiar coef4, aux_coef
                    jmp    finish
    coeficiente3:   
                    Copiar coef3, aux_coef
                    jmp    finish
    coeficiente2:   
                    Copiar coef2, aux_coef
                    jmp    finish
    coeficiente1:   
                    Copiar coef1, aux_coef
                    jmp    finish
    coeficiente0:   
                    Copiar coef0, aux_coef

    finish:         

                    pop    bx
ENDM
~~~

### Graph_Function
<p>Inicia el modo video y dibuja la grafica, termina pasando a modo texto.</p>

~~~
Graph_Function macro
                   AsciiToNumber       ; Para las variables que almacenan los coeficientes
                   ModoVideo
                   Draw_Axis
                   Choose_Function
                   pressKey            ;Press a key to continue
                   ModoTexto           ;back to text mode
endm
~~~

### Graph_Derivative
<p>Inicia el modo video y dibuja la grafica de la derivada, termina pasando a modo texto</p>

~~~
Graph_Derivative macro
                     AsciiToNumber           ; Para las variables que almacenan los coeficientes
                     Set_Coef_Derivative
                     ModoVideo
                     Draw_Axis
                     Choose_Derivative
                     pressKey                ;Press a key to continue
                     ModoTexto               ;back to text mode
endm
~~~

### ModoVideo
<p>Inicializa la interrupcion para modo video.</p>

~~~
ModoVideo macro
    ;resolucion de 320x180
              mov ax, 0013h
              int 10h
    ;mov ax, 0A000h
    ;mov ds, ax        ; DS = A000h (memoria de graficos).
endm
~~~

### ModoTexto
<p>Inicializa la interrupcion para modo texto.</p>

~~~
ModoTexto macro
              mov al, 0003h
              int 10h
endm
~~~

### Draw_Pixel
<p>Dibuja el pixel especificado por la posicion que se le pasa por parametros.</p>

~~~
Draw_Pixel macro coorX, coorY, color
               local fin
               xor   si, si
               mov   si, coorY
               cmp   si, 0
               jl    fin
               cmp   si, 200
               jg    fin
               pusha
               mov   ah, 0ch
               mov   al, color
               mov   bh, 0h
               mov   dx, coorY
               mov   cx, coorX
               int   10h
               popa
    fin:       
endm
~~~

### Draw_Axis
<p>Dibuja los ejes X y Y, en una pantalla 320x180</p>

~~~
Draw_Axis macro
              local      eje_x, eje_y
              xor        cx, cx
              mov        cx, 320
    eje_x:    
              Draw_Pixel cx, 100, 4fh
              loop       eje_x
              mov        cx, 200
    eje_y:    
              Draw_Pixel 160, cx, 4fh
              loop       eje_y
endm
~~~

### Choose_Function
<p>Elige y ejecuta el grado al que se hara la grafica</p>

~~~
Choose_Function macro
                    LOCAL            isFourthGrade, isCubic, isCuadratic, isLineal, isConstant, finish
                    cmp              coef4[1], 0
                    jne              isFourthGrade
                    cmp              coef3[1], 0
                    jne              isCubic
                    cmp              coef2[1], 0
                    jne              isCuadratic
                    cmp              coef1[1], 0
                    jne              isLineal
                    cmp              coef0[0], 0
                    jne              isConstant
                    jmp              finish

    isFourthGrade:  
                    Execute_4Grade
                    jmp              finish
    isCubic:        
                    Execute_3Grade   coef3,coef2,coef1,coef0
                    jmp              finish
    isCuadratic:    
                    Execute_2Grade   coef2, coef1, coef0
                    jmp              finish
    isLineal:       
                    Execute_1Grade   coef1, coef0
                    jmp              finish
    isConstant:     
                    Execute_Constant coef0
                    jmp              finish
    finish:         

endm
~~~

### Execute_4Grade
<p>Verifica la funcion es negativa o positiva. Envia registros para que se ajusten a los intervalos. Para una funcion de grado 4</p>

~~~
Execute_4Grade macro
                   LOCAL        while, is_negative, is_positive, continue, finish
                   xor          ax, ax
                   xor          bx, bx
                   xor          cx, cx                                               ;cl = intervaloI | ch = intertervaloF
                   mov          cl, var_intervaloI[1]
                   mov          ch, var_intervaloF[1]

    while:         
                   xor          ax, ax
                   mov          bl, 160                                              ;x
                   mov          dl, 100                                              ;y (160,100) - (0,0)
    ;checkSign
                   test         cl,cl
                   js           is_negative
                   jmp          is_positive
    ;---------------Axis x----------------
    is_negative:   
                   neg          cl
                   sub          bl, cl                                               ;where x start
    ;y
                   PosicionarX4
                   neg          cl
                   jmp          continue
    is_positive:   
                   mul          cl
                   add          bl, cl
                   PosicionarX4
    ;-------------Axis y-------------------
    continue:      
    ;Draw
                   Draw_Pixel   bx, dx, 0ch
                   inc          cl
                   cmp          cl, ch
                   jg           finish
                   jmp          while
    finish:        
endm
~~~

### PosicionarX4
<p>Posiciona los registros bx y dx para que se puedan graficar en la pantalla. Para una funcion de grado 4</p>

~~~
PosicionarX4 macro
                 LOCAL          coefficient3, coefficient2, coefficient1, coefficient0, minus4,minus3,minus2,minus1,minus, fin
    ;Coefficient 4
                 cmp            cl, 10
                 jg             fin

                 cmp            coef4[0], 45
                 je             minus4
    ;x^4
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 4, cx
                 popExceptAx
    ;------------------c4 * x^4----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef4[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor            dx, dx
                 mov            cx, 500
                 div            cx
                 popExceptAx
    ;----------------real value---------------
                 sub            dx, ax
                 jmp            coefficient3
    minus4:      
    ;------------------x^4--------------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 4, cx
                 popExceptAx
    ;-----------------c4 * x^4----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef4[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd----------------
                 push           cx
                 mov            cx, 500
                 div            cx
                 pop            cx
    ;----------------real value---------------
                 add            dx, ax
    coefficient3:
                 cmp            coef3[0], 45
                 je             minus3
    ;----------------x^3---------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 3, cx
                 popExceptAx
    ;------------------c3 * x^3----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef3[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor            dx, dx
                 mov            cx, 500
                 div            cx
                 popExceptAx
    ;----------------real value---------------
                 sub            dx, ax
                 jmp            coefficient2
    minus3:      
    ;------------------x^3--------------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 3, cx
                 popExceptAx
    ;-----------------c3 * x^3----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef3[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd----------------
                 push           cx
                 mov            cx, 500
                 div            cx
                 pop            cx
    ;----------------real value---------------
                 add            dx, ax
    coefficient2:
                 cmp            coef2[0],45
                 je             minus2
    ;----------------x^2---------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 2, cx
                 popExceptAx
    ;------------------c2 * x^2----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef2[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor            dx, dx
                 mov            cx, 500
                 div            cx
                 popExceptAx
    ;----------------real value---------------
                 sub            dx, ax
                 jmp            coefficient1
    minus2:      
    ;------------------x^2--------------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 2, cx
                 popExceptAx
    ;-----------------c2 * x^2----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef2[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd----------------
                 push           cx
                 mov            cx, 500
                 div            cx
                 pop            cx
    ;----------------real value---------------
                 add            dx, ax
    coefficient1:
                 cmp            coef1[0], 45
                 je             minus1
    ;----------------x^1---------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 1, cx
                 popExceptAx
    ;------------------c1 * x^1----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef1[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor            dx, dx
                 mov            cx, 500
                 div            cx
                 popExceptAx
    ;----------------real value---------------
                 sub            dx, ax
                 jmp            coefficient0
    minus1:      
    ;------------------x^1--------------------
                 pushExceptAX
                 xor            ch, ch
                 Solve_Potencia 3, cx
                 popExceptAx
    ;-----------------c1 * x^1----------------
                 push           dx
                 xor            dx, dx
                 mov            dl, coef1[1]
                 mul            dx
                 pop            dx
    ;-----------------scale xd----------------
                 push           cx
                 mov            cx, 500
                 div            cx
                 pop            cx
    ;----------------real value---------------
                 add            dx, ax
    coefficient0:
                 cmp            coef0[0], 45
                 je             minus
                 push           cx
                 xor            ch, ch
                 mov            cl, coef0[1]
                 sub            dx, cx
                 pop            cx
                 jmp            fin
    minus:       
                 push           cx
                 xor            ch, ch
                 mov            cl, coef0[1]
                 add            dx, cx
                 pop            cx
    fin:         

endm
~~~

### Solve_Potencia
<p>Resuelve la potencia de los parametros que se le envian.</p>

~~~
Solve_Potencia macro exponente, value
                   LOCAL while, finish
                   xor   bx, bx
                   mov   bl, exponente
                   mov   ax, 1

                   cmp   bl, 0
                   jg    while
                   jmp   finish

    while:         
                   cmp   bx, 1
                   jl    finish
                   mul   value
                   dec   bx
                   jmp   while
    finish:        
endm
~~~