include macros.asm

;--------------------------------------------------------------
; SEGMENTO PRINCIPAL model (puede ser: tiny, small, medium, large)
;--------------------------------------------------------------
.model small
;--------------------------------------------------------------
; SEGMENTO PRINCIPAL stack (manejo de pila. Puede tener valor: .stack[size])
;--------------------------------------------------------------
.stack
    ;--------------------------------------------------------------
    ; SEGMENTO PRINCIPAL  data (para todas las variables)
    ;--------------------------------------------------------------
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
    prueba5                    db 'Opcion 5 no implementada', 13, 10, '$'
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

    ;--------------------------------------------------------------
    ; SEGEMENTO PRINCIPAL code (para procedimiento y funciones)
    ;--------------------------------------------------------------
.code

    ; L E E R   L I N E A   D E   E N T R A D A **************************************************************
    ; Captura la cadena ingresada por consola (caracter a caracter)
CONSOLE_IN PROC
                      mov                  si, offset var_input
    Loop_input:       
                      mov                  ah, 1                               ;read character from standard input, with echo, result is stored in AL. If there is no character in the keyboard buffer, the function waits until any key is pressed.
                      int                  21h
                      cmp                  al, 13                              ;COMPARAR CON \n
                      je                   Concat_input                        ;SALTA SI LA COMPARACION ES IGUAL
                      mov                  [si], al                            ;AGREGAR A MEMORIA EL DATO INGRESADO
                      inc                  si                                  ;PASAR A LA SIGUIENTE CELDA
                      jmp                  Loop_input                          ;FIN DEL LOOP
    Concat_input:     
                      mov                  di, offset var_input
                      ret
CONSOLE_IN ENDP

    ; M E T O D O   S A L I R ********************************************************************************
    ; Permite la terminacion de la aplicacion
SALIR PROC
                      mov                  ax, 4C00H
                      int                  21h
SALIR ENDP

    ; M E T O D O   L I M P I A R   R E G I S T R O S ********************************************************
    ; Limpia los registros utilizados, poniendo a 0 los registros con el xor
LIMPIAR_R PROC
                      xor                  ax, ax
                      xor                  bx, bx
                      xor                  cx, cx
                      xor                  dx, dx
                      ret
LIMPIAR_R ENDP

    ; M E T O D O   L I M P I A R   E N T R A D A ****************************************************************
    ; Remueve de SI la cadena ingresada
LIMPIAR_ENTRADA PROC
                      mov                  si, 0
    l_ciclo:          
                      mov                  var_input[si], '$'
                      inc                  si
                      cmp                  var_input[si], '$'
                      jne                  l_ciclo
                      mov                  si, 0
                      ret
LIMPIAR_ENTRADA ENDP

    ; M E T O D O   F U N C I O N   E N T R A D A ****************************************************************
    ; Se ingresa la funcion y se hace split de los coeficientes. Valida que no este mal escrita. Guarda la funcion
FUNCTION_IN PROC
                      mov                  is_funtion_error, 0                 ; QUITAR FLAG DE ERROR EN LA FUNCION
                      CONSOLE_OUT          alert_write_funtion                 ; MOSTRAR MENSAJE DE ESCRIBIR FUNCION
                      call                 CONSOLE_IN                          ; ALMACENAR LO INGRESADO
                      SepararTerminos      var_input                           ; SEPARAR TERMINOS Y VALIDAR QUE TODO ESTE BIEN
                      cmp                  is_funtion_error, 1                 ; VALIDAR SI EXISTIO ALGUN ERROR
                      je                   mostrar_error                       ; SALTAR A LA ETIQUETA QUE MUESTRA EL ERROR
                      GuardarFuncion       var_input                           ; SI TODO ESTA BIEN, SE GUARDA LA FUNCION (ECUACION)
                      CONSOLE_OUT          alert_saveSuccess_funtion           ; MOSTRAR MENSAJE DE GUARDADO EXITOSO
                      jmp                  if_salir                            ; TERMINAR EL PROCEDIMIENTO DE INGRESAR FUNCION
    mostrar_error:    
                      CONSOLE_OUT          alert_bad_write_funtion
    if_salir:         
                      LimpiarVariable      var_input                           ; LIMPIA LA VARIABLE QUE ALMACENARA UNA NUEVA ENTRADA POR CONSOLA
                      ret
FUNCTION_IN ENDP

    ; METODO LIMPIAR CONSOLA
    ; Limpia todo el procedimiento mostrado en consola anterior al llamado del metodo
CLEAR_SCREEN PROC
                      mov                  ah, 0h                              ; Set video mode
                      mov                  al, 3                               ; text mode. 80x25. 16 colors. 8 pages
                      int                  10H                                 ; Interruption
                      ret
CLEAR_SCREEN ENDP

    ; M E T O D O   I M P R I M I R   F U N C I O N E S ***************************************************************
    ; Imprime las 20 variables que almacenan las funciones. Muestra 'Espacio libre' si aun no se ocupa con una Ecuacion la variable
SHOW_FUNCTIONS proc
                      mov                  funtion_id[2], 'A'                  ; Sustituye el mensaje original por la letra asignada
                      CONSOLE_OUT          funtion_id                          ; Imprime el ID de la funcion a mostrar
                      PrintFuntion         func_1                              ; Imprime la funcion

                      mov                  funtion_id[2], 'B'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_2

                      mov                  funtion_id[2], 'C'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_3

                      mov                  funtion_id[2], 'D'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_4

                      mov                  funtion_id[2], 'E'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_5
        
                      mov                  funtion_id[2], 'F'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_6

                      mov                  funtion_id[2], 'G'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_7

                      mov                  funtion_id[2], 'H'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_8

                      mov                  funtion_id[2], 'I'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func_9

                      mov                  funtion_id[2], 'J'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func10

                      mov                  funtion_id[2], 'K'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func11

                      mov                  funtion_id[2], 'L'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func12

                      mov                  funtion_id[2], 'M'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func13

                      mov                  funtion_id[2], 'N'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func14

                      mov                  funtion_id[2], 'O'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func15

                      mov                  funtion_id[2], 'P'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func16

                      mov                  funtion_id[2], 'Q'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func17

                      mov                  funtion_id[2], 'R'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func18

                      mov                  funtion_id[2], 'S'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func19

                      mov                  funtion_id[2], 'T'
                      CONSOLE_OUT          funtion_id
                      PrintFuntion         func20
                      ret
SHOW_FUNCTIONS endp

    ; D E R I V A R   F U N C I O N ******************************************************************************
    ; Hace el split de la funcion seleccionada y la resuelve para mostrar la derivada
DERIVAR_FUNCTION proc
                      CONSOLE_OUT          alert_write_id_funtion              ; PIDE QUE SE INGRESE LA LETRA (ID) DE LA FUNCION A DERIVAR
                      call                 CONSOLE_IN                          ; SE LLAMA LA FUNCION PARA LEER LO INGRESADO
                      LimpiarVariable      var_funcion                         ; SE REINICIA LA VARIABLE QUE ALMACENARA LA FUNCION SELECCINADA
                      SeleccionarFuncion   var_input                           ; SE BUSCA LA FUNCION Y SE ALMACENA EN LA VARIABLE var_funcion
                      CONSOLE_OUT          funcion_selected                    ; SE IMPRIME LA FUNCION SELECCIONA
                      CONSOLE_OUT          var_funcion                         ; SE IMPRIME LA FUNCION SELECCINADA

                      LimpiarVariable      arr_exponentes                      ; SE REINICIA LA VARIABLE QUE ALMACENA LOS EXPONENTES DE LA FUNCION
                      LimpiarVariable      arr_coeficientes                    ; SE REINICIA LA VARIABLE QUE CONTIENE LOS COEFICIENTE DE LA FUNCION
                      Split_Funtion        var_funcion                         ; SEPARA LA FUNCION POR COEFICIENTES Y EXPONENTES PARA ALMACENARLOS EN SU VARIABLE RESPECTIVA
                      CONSOLE_OUT          show_derivada                       ; MENSAJE PARA INDICAR LA DERIVADA ES
                      Solve_Derivation     arr_coeficientes, arr_exponentes    ; MUESTRA LA DERIVADA DE LA FUNCION
                      ret
DERIVAR_FUNCTION endp

    ; I N T E G R A R   F U N C I O N ****************************************************************************
    ; Hace el split de la funcion seleccionada entre coeficientes y exponentes para luego resolverla y mostrar la integral
FUNCTION_INTEGRAL proc
                      CONSOLE_OUT          alert_write_id_funtion              ; PIDE QUE SE INGRESE LA LETRA (ID) DE LA FUNCION A INTEGRAR
                      call                 CONSOLE_IN                          ; SE LLAMA LA FUNCION PARA LEER LO INGRESADO
                      LimpiarVariable      var_funcion                         ; SE REINICIA LA VARIABLE QUE ALMACENARA LA FUNCION SELECCINADA
                      SeleccionarFuncion   var_input                           ; SE BUSCA LA FUNCION Y SE ALMACENA EN LA VARIABLE var_funcion
                      CONSOLE_OUT          funcion_selected                    ; SE IMPRIME LA FUNCION SELECCIONA
                      CONSOLE_OUT          var_funcion                         ; SE IMPRIME LA FUNCION SELECCINADA

                      LimpiarVariable      arr_exponentes                      ; SE REINICIA LA VARIABLE QUE ALMACENA LOS EXPONENTES DE LA FUNCION
                      LimpiarVariable      arr_coeficientes                    ; SE REINICIA LA VARIABLE QUE CONTIENE LOS COEFICIENTE DE LA FUNCION
                      Split_Funtion        var_funcion                         ; SEPARA LA FUNCION POR COEFICIENTES Y EXPONENTES PARA ALMACENARLOS EN SU VARIABLE RESPECTIVA
                      CONSOLE_OUT          show_integral                       ; MENSAJE PARA INDICAR LA INTEGRAL ES
                      Solve_Integral       arr_coeficientes, arr_exponentes    ; RESUELVE Y MUESTRA LA INTEGRAL DE LA FUNCION
                      ret
FUNCTION_INTEGRAL endp

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
    l_graph_function: 
                      call                 CLEAR_SCREEN
                      CONSOLE_IN_INTERVALS
                      call                 INIT_COEFICIENTES
                      Split_Coeficientes   var_funcion
                      Graph_Function
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

    ;description
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

FIN_VIDEO proc
                      mov                  ax, 0003h
                      int                  10h
                      mov                  ax, @data
                      mov                  ds, ax
                      ret
FIN_VIDEO endp

    ; M A I N ************************************************************************************************
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
end MAIN