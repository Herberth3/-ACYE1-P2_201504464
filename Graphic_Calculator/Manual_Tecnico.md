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
- Arduino IDE
    - Versión: 1.8.15.0
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

    ; Variables globales
    var_input                  db 35 dup('$')                                                                                           ; ALMACENA LO INGRESADO POR CONSOLA
    var_termino                db 10 dup('$')                                                                                           ; ALMACENA EL TÉRMINO QUE SE ESTÁ TRABANDO
    var_funcion                db 35 dup('$')                                                                                           ; ALMACENA LA FUNCION QUE SE SELECCIONO Y LA UTILIZA PARA DERIVAR O INTEGRAR
    arr_exponentes             db 15 dup('$')                                                                                           ; LIMITADO A 15 TÉRMINOS
    arr_coeficientes           db 15 dup('$')                                                                                           ; LIMITADO A 15 TÉRMINOS
    var_exp                    db 0
    var_coef                   db 0
    var16_coef                 dw 0
    prueba5                    db 'Opcion 5 no implementada', 13, 10, '$'
    prueba6                    db 'Opcion 6 no implementada', 13, 10, '$'
    prueba7                    db 'Opcion 7 no implementada', 13, 10, '$'

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
    funtion_id                 db 13, 10, '0: $'
    free_space_funtion         db 'Espacio libre $'
    funcion_select             db 13, 10, 'Funcion seleccionada: $'
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
                     mov                ax, @data
                     mov                ds, ax

    ; Etiqueta para crear un loop del menu
    Loop_menu:       
                     call               CLEAR_SCREEN                        ; Limpia la consola para solo mostrar el menu
                     CONSOLE_OUT        menu_header                         ; Muestra el menu en consola
                     call               CONSOLE_IN                          ; Capturla lo ingresado por consola
                     call               LIMPIAR_R                           ; Actualiza los registros

                     cmp                var_input[0], '1'                   ; Si es igual, se llama a la funcion para Ingresar Ecuacion
                     jne                Option2                             ; Si es diferente, salta a la siguiente opcion
                     call               FUNTION_IN                          ; Llamada al procedimiento
                     jmp                New_loop_menu
    Option2:         
                     cmp                var_input[0], '2'                   ; Si es igual, se llama a la funcion para Imprimir la Ecuacion
                     jne                Option3                             ; Si es diferente, salta a la siguiente opcion
                     call               SHOW_FUNTIONS                       ; Llamada al procedimiento
                     jmp                New_loop_menu
    Option3:         
                     cmp                var_input[0], '3'                   ; Si es igual, se llama a la funcion para Imprimir la Derivada
                     jne                Option4                             ; Si es diferente, salta a la siguiente opcion
                     call               DERIVAR_FUNTION                     ; Llamada al procedimiento
                     jmp                New_loop_menu
    Option4:         
                     cmp                var_input[0], '4'                   ; Si es igual, se llama a la funcion para Imprimir la Integral
                     jne                Option5                             ; Si es diferente, salta a la siguiente opcion
                     call               FUNTION_INTEGRAL                    ; Llamada al procedimiento
                     jmp                New_loop_menu
    Option5:         
                     cmp                var_input[0], '5'                   ; Si es igual, se llama a la funcion para Graficar Funcion, Derivada, Integral
                     jne                Option6                             ; Si es diferente, salta a la siguiente opcion
                     CONSOLE_OUT        prueba5
                     jmp                New_loop_menu
    Option6:         
                     cmp                var_input[0], '6'                   ; Si es igual, se llama a la funcion para Encontrar ceros de la funcion por Newton
                     jne                Option7                             ; Si es diferente, salta a la siguiente opcion
                     CONSOLE_OUT        prueba6
                     jmp                New_loop_menu
    Option7:         
                     cmp                var_input[0], '7'                   ; Si es igual, se llama a la funcion para Encontrar ceros de la funcion por Steffensen
                     jne                Option8                             ; Si es diferente, salta a la siguiente opcion
                     CONSOLE_OUT        prueba7
                     jmp                New_loop_menu
    Option8:         
                     cmp                var_input[0], '8'                   ; Si es igual, se llama a la funcion para Salir
                     jne                Option_not_found
                     call               SALIR                               ; Llama al procedimiento para terminar la aplicacion

    New_loop_menu:   
                     CONSOLE_OUT        alert_press_enter                   ; Imprime peticion de presionar enter
                     call               CONSOLE_IN                          ; Lee el salto de linea (ENTER) ingresado
                     call               LIMPIAR_ENTRADA                     ; Vacia lo almacenado en SI
                     jmp                Loop_menu                           ; Muestra de nuevo el menu

    Option_not_found:
                     CONSOLE_OUT        alert_option_not_valid              ; Mostrar mensaje de opcion no valida
                     CONSOLE_OUT        alert_press_enter                   ; Imprime peticion de presionar enter
                     call               CONSOLE_IN                          ; Lee el salto de linea (ENTER) ingresado
                     call               LIMPIAR_ENTRADA                     ; Vacia lo almacenado en SI
                     jmp                Loop_menu                           ; Muestra de nuevo el menu

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