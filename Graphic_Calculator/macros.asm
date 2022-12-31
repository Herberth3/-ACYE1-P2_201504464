;-------------------------------------
;           IMPRIMIR CADENA
;-------------------------------------    
CONSOLE_OUT macro cadena
                push dx
                push ax
                mov  ah, 09h              ; output of a string at DS:DX. String must be terminated by '$'
                mov  dx, offset cadena    ; string a mostrar
                int  21h                  ; Interruption
                pop  ax
                pop  dx
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   SEPARAR FUNCIÓN POR TÉRMINOS
; Ejemplo de una funcion: -42x^5+44x^4+33x^3+22x^2-22x^1+1
; Ejemplo de una funcion:  x^4+x^3-22x+1
;-----------------------------------------------------------------------------------------------------------------------------    
SepararTerminos macro funcion
                    local            ciclo, seguir, seguir2, negativo, termino, errorxd, finxd    ; ETIQUETAS DE LA MACRO
                    push             si
                    push             di
                    push             ax

                    mov              si, 0
                    mov              di, 0
    ciclo:          
                    cmp              funcion[si], '-'                                             ; COMPARA SI EL CARACTER ES UN MENOS (-)
                    je               negativo                                                     ; SALTA SI ES IGUAL AL MENOS
                    cmp              funcion[si], '+'                                             ; COMPARA SI EL CARACTER ES UN MAS (+)
                    je               termino                                                      ; SALTA SI ES IGUAL AL MAS
    seguir:         
                    mov              al, funcion[si]                                              ; SE ALMACENA EN AL EL CARACTER COMO REGISTRO DE 8 BITS
                    mov              var_termino[di], al                                          ; SE ALMACENA EN LA VARABLE GLOBAL EN CARACTER
                    inc              di
                    inc              si
                    cmp              funcion[si], '$'                                             ; SE CONSULTA SI AUN HAY CARACTERES PARA LEER
                    jne              ciclo                                                        ; SI AUN HAY CARACTERES SE SIGUE LEYENDO
                    jmp              termino
    negativo:       
                    cmp              var_termino[0], '$'
                    je               seguir
                    dec              si
    termino:        
                    ComprobarTermino var_termino
                    cmp              is_error_termino, 0
                    je               seguir2
                    mov              is_error_funcion, 1                                          ;GLOBAL
    seguir2:        
                    LimpiarVariable  var_termino
                    mov              di, 0
                    inc              si
                    cmp              funcion[si], '$'
                    jne              ciclo
    finxd:          
                    pop              ax
                    pop              di
                    pop              si
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   COMPROBAR TÉRMINO
;-----------------------------------------------------------------------------------------------------------------------------    
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

;-----------------------------------------------------------------------------------------------------------------------------
;   ES NUMERO UN CHAR?
; Comprueba que el caracter sea un numero   
EsNumero macro char
             local y, es_num, no_num, fin
             mov   is_numero, 0
    ;si char >= '0' and char <= '9'
             cmp   char, '0'
             jae   y
             jmp   no_num
    y:       
             cmp   char, '9'
             jbe   es_num
             jmp   no_num

    es_num:  
             mov   is_numero, 1
             jmp   fin
    no_num:  
             mov   is_numero, 0
    fin:     
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   ES UN EXPONENTE EL CHAR?
; Comprueba que el caracter sea un numero entre 1-5    
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

;-----------------------------------------------------------------------------------------------------------------------------
;   LIMPIAR VARIABLE
; Reinicia la variable que se le pasa por parametro a su estado inicial ($$$$$$)   
LimpiarVariable macro array
                    local ciclo
                    push  si
                    mov   si, 0
    ciclo:          
                    mov   array[si], '$'
                    inc   si
                    cmp   array[si], '$'
                    jne   ciclo
                    pop   si
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   GUARDAR FUNCIÓN
; Almacena en la lista de funciones la nueva funcion que se ha ingresado
GuardarFuncion macro funcion
                   local       s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,nohay,exit
                   cmp         func_1[0], '$'
                   jne         s2
                   Copiar      func_1, funcion
                   jmp         exit
    s2:            
                   cmp         func_2[0], '$'
                   jne         s3
                   Copiar      func_2, funcion
                   jmp         exit
    s3:            
                   cmp         func_3[0], '$'
                   jne         s4
                   Copiar      func_3, funcion
                   jmp         exit
    s4:            
                   cmp         func_4[0], '$'
                   jne         s5
                   Copiar      func_4, funcion
                   jmp         exit
    s5:            
                   cmp         func_5[0], '$'
                   jne         s6
                   Copiar      func_5, funcion
                   jmp         exit
    s6:            
                   cmp         func_6[0], '$'
                   jne         s7
                   Copiar      func_6, funcion
                   jmp         exit
    s7:            
                   cmp         func_7[0], '$'
                   jne         s8
                   Copiar      func_7, funcion
                   jmp         exit
    s8:            
                   cmp         func_8[0], '$'
                   jne         s9
                   Copiar      func_8, funcion
                   jmp         exit
    s9:            
                   cmp         func_9[0], '$'
                   jne         s10
                   Copiar      func_9, funcion
                   jmp         exit
    s10:           
                   cmp         func10[0], '$'
                   jne         s11
                   Copiar      func10, funcion
                   jmp         exit
    s11:           
                   cmp         func11[0], '$'
                   jne         s12
                   Copiar      func11, funcion
                   jmp         exit
    s12:           
                   cmp         func12[0], '$'
                   jne         s13
                   Copiar      func12, funcion
                   jmp         exit
    s13:           
                   cmp         func13[0], '$'
                   jne         s14
                   Copiar      func13, funcion
                   jmp         exit
    s14:           
                   cmp         func14[0], '$'
                   jne         s15
                   Copiar      func14, funcion
                   jmp         exit
    s15:           
                   cmp         func15[0], '$'
                   jne         s16
                   Copiar      func15, funcion
                   jmp         exit
    s16:           
                   cmp         func16[0], '$'
                   jne         s17
                   Copiar      func16, funcion
                   jmp         exit
    s17:           
                   cmp         func17[0], '$'
                   jne         s18
                   Copiar      func17, funcion
                   jmp         exit
    s18:           
                   cmp         func18[0], '$'
                   jne         s19
                   Copiar      func18, funcion
                   jmp         exit
    s19:           
                   cmp         func19[0], '$'
                   jne         s20
                   Copiar      func19, funcion
                   jmp         exit
    s20:           
                   cmp         func20[0], '$'
                   jne         nohay
                   Copiar      func20, funcion
                   jmp         exit
    nohay:         
                   CONSOLE_OUT alert_overflow_funtions
    exit:          
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   COPIAR FUNCIÓN
; Copia la nueva funcion que se ingreso a una de las variables que se utilizan para almacenar funciones
Copiar macro var1, var2
           local More
           push  si
           push  di
           push  ax
           mov   di, 0
           mov   si, 0
    More:  
           mov   al, var2[di]
           mov   var1[si], al
           inc   si
           inc   di
           cmp   var2[di], "$"
           jne   More
           pop   ax
           pop   di
           pop   si
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
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

;-----------------------------------------------------------------------------------------------------------------------------
;   SELECCIONAR FUNCIÓN 
; Copia en una variable auxiliar (var_funcion) la funcion que se selecciono para integrarla o derivarla
SeleccionarFuncion macro id
                       local       s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,nohay,exit
                       push        si
                       mov         si, 0
                       cmp         id[si], 'A'
                       jne         s2
                       Copiar      var_funcion, func_1
                       jmp         exit
    s2:                
                       cmp         id[si], 'B'
                       jne         s3
                       Copiar      var_funcion, func_2
                       jmp         exit
    s3:                
                       cmp         id[si], 'C'
                       jne         s4
                       Copiar      var_funcion, func_3
                       jmp         exit
    s4:                
                       cmp         id[si], 'D'
                       jne         s5
                       Copiar      var_funcion, func_4
                       jmp         exit
    s5:                
                       cmp         id[si], 'E'
                       jne         s6
                       Copiar      var_funcion, func_5
                       jmp         exit
    s6:                
                       cmp         id[si], 'F'
                       jne         s7
                       Copiar      var_funcion, func_6
                       jmp         exit
    s7:                
                       cmp         id[si], 'G'
                       jne         s8
                       Copiar      var_funcion, func_7
                       jmp         exit
    s8:                
                       cmp         id[si], 'H'
                       jne         s9
                       Copiar      var_funcion, func_8
                       jmp         exit
    s9:                
                       cmp         id[si], 'I'
                       jne         s10
                       Copiar      var_funcion, func_9
                       jmp         exit
    s10:               
                       cmp         id[si], 'J'
                       jne         s11
                       Copiar      var_funcion, func10
                       jmp         exit
    s11:               
                       cmp         id[si], 'K'
                       jne         s12
                       Copiar      var_funcion, func11
                       jmp         exit
    s12:               
                       cmp         id[si], 'L'
                       jne         s13
                       Copiar      var_funcion, func12
                       jmp         exit
    s13:               
                       cmp         id[si], 'M'
                       jne         s14
                       Copiar      var_funcion, func13
                       jmp         exit
    s14:               
                       cmp         id[si], 'N'
                       jne         s15
                       Copiar      var_funcion, func14
                       jmp         exit
    s15:               
                       cmp         id[si], 'O'
                       jne         s16
                       Copiar      var_funcion, func15
                       jmp         exit
    s16:               
                       cmp         id[si], 'P'
                       jne         s17
                       Copiar      var_funcion, func16
                       jmp         exit
    s17:               
                       cmp         id[si], 'Q'
                       jne         s18
                       Copiar      var_funcion, func17
                       jmp         exit
    s18:               
                       cmp         id[si], 'R'
                       jne         s19
                       Copiar      var_funcion, func18
                       jmp         exit
    s19:               
                       cmp         id[si], 'S'
                       jne         s20
                       Copiar      var_funcion, func19
                       jmp         exit
    s20:               
                       cmp         id[si], 'T'
                       jne         nohay
                       Copiar      var_funcion, func20
                       jmp         exit
    nohay:             
                       CONSOLE_OUT alert_incorrent_id_funtion
    exit:              
                       pop         si
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   SEPARAR FUNCIÓN POR TÉRMINOS PARA LECTURA
;-----------------------------------------------------------------------------------------------------------------------------    
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

;-----------------------------------------------------------------------------------------------------------------------------
;   COMPROBAR TÉRMINO
;-----------------------------------------------------------------------------------------------------------------------------    
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
                add          var_coef, al

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

;-----------------------------------------------------------------------------------------------------------------------------
;   AGREGAR A LISTA
;-----------------------------------------------------------------------------------------------------------------------------    
AgregarLista macro array, valor
                 local ciclo, compar
                 push  si
                 push  cx
                 mov   si, 0
                 jmp   compar
    ciclo:       
                 inc   si
    compar:      
                 cmp   array[si], '$'
                 jne   ciclo
    
                 mov   cl, valor
                 mov   array[si], cl

                 pop   cx
                 pop   si
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   DERIVAR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
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

;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR CON MENOS Y MÁS
;----------------------------------------------------------------------------------------------------------------------------- 
Imprimir16ConMasyMenos macro valor
                           local          negat, pos, irse
        
                           cmp            valor, 32768
                           jnc            negat
                           jmp            pos

    negat:                 
                           CONSOLE_OUT    signo_menos
                           neg            valor
                           Imprimir16bits valor
                           jmp            irse
    pos:                   
                           CONSOLE_OUT    signo_mas
                           Imprimir16bits valor
    irse:                  
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR 16 BITS
;-----------------------------------------------------------------------------------------------------------------------------    
Imprimir16bits macro registro
                   local       cualquiera,noz,dig2,dig3,dig5,dig22,dig23,dig25
                   xor         ax, ax
                   mov         ax, registro
                   mov         cx, 10

                   cmp         registro, 10
                   jae         dig2
                   mov         bx, 1
                   jmp         cualquiera
    dig2:          
                   cmp         registro, 100
                   jae         dig3
                   mov         bx, 2
                   jmp         cualquiera
    dig3:          
                   cmp         registro, 1000
                   jae         dig5
                   mov         bx, 3
                   jmp         cualquiera
    dig5:          
                   mov         bx, 5
    cualquiera:    
                   xor         dx, dx
                   div         cx
                   push        dx
                   dec         bx
                   jnz         cualquiera
    
                   cmp         registro, 10
                   jae         dig22
                   mov         bx, 1
                   jmp         noz
    dig22:         
                   cmp         registro, 100
                   jae         dig23
                   mov         bx, 2
                   jmp         noz
    dig23:         
                   cmp         registro, 1000
                   jae         dig25
                   mov         bx, 3
                   jmp         noz
    dig25:         
                   mov         bx, 5

    noz:           
                   pop         dx
                   PrintNumber dl
                   dec         bx
                   jnz         noz
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR NÚMERO
;-----------------------------------------------------------------------------------------------------------------------------    
PrintNumber macro registro
                push ax
                push dx

                mov  dl, registro
    ;ah = 2
                add  dl, 48
                mov  ah, 02h
                int  21h

                pop  dx
                pop  ax
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR 8 BITS
;-----------------------------------------------------------------------------------------------------------------------------    
Imprimir8bits macro registro
                  local       cualquiera, noz, dig2, dig22
                  push        ax
                  push        bx
                  push        cx

                  xor         ax, ax
                  mov         al, registro
                  mov         cx, 10
    
                  cmp         registro, 10
                  jae         dig2
                  mov         bx, 1
                  jmp         cualquiera
    dig2:         
                  mov         bx, 2

    cualquiera:   
                  xor         dx, dx
                  div         cx
                  push        dx
                  dec         bx
                  jnz         cualquiera

                  cmp         registro, 10
                  jae         dig22
                  mov         bx, 1
                  jmp         noz
    dig22:        
                  mov         bx, 2

    noz:          
                  pop         dx
                  PrintNumber dl
                  dec         bx
                  jnz         noz

                  pop         cx
                  pop         bx
                  pop         ax
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   INTEGRAR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
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

;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR 8 BITS CON MENOS Y MÁS
;----------------------------------------------------------------------------------------------------------------------------- 
Imprimir8ConMasyMenos macro valor
                          local         negat, pos, irse
        
                          cmp           valor, 128
                          jnc           negat
                          jmp           pos

    negat:                
                          CONSOLE_OUT   signo_menos
                          neg           valor
                          Imprimir8bits valor
                          jmp           irse
    pos:                  
                          CONSOLE_OUT   signo_mas
                          Imprimir8bits valor
    irse:                 
endm

; ****************************************************************************************************************************
;   M O D O   V I D E O   P A R A   G R A F I C A S
; ****************************************************************************************************************************

;-----------------------------------------------------------------------------------------------------------------------------
;   CONSOLE IN PARA INTERVALOS
; Pide que se ingresen los intervalos para mostrar la grafica. Puede ser desde -99 a 99
;-----------------------------------------------------------------------------------------------------------------------------
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
                  local     order, finish
    ;Todo check if the length don't pass the limit
                  CheckLength var
                  cmp       si, 2
                  je        order
                  jmp       finish
    
    order:        
                  xor       bx, bx
                  mov       bl, var[0]
                  mov       bh, var[1]
                  mov       var[0], 43
                  mov       var[1], bl
                  mov       var[2], bh
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

;------------------------------------------------------------------------------------------------------------------------------------------------
;   SPLIT COEFICIENTES
;   Extrae los coeficientes de la funcion ingresada con su signo
;------------------------------------------------------------------------------------------------------------------------------------------------
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
;   Asigna cada coeficiente extraido a una de las 5 variables que necesito para grafiar
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

;----------------------------------------------------------------------------------------
;   GRAPH FUNCTION
; Inicia el modo video y dibuja la grafica, termina pasando a modo texto
;----------------------------------------------------------------------------------------
Graph_Function macro
                   AsciiToNumber    ; Para las variables que almacenan los coeficientes
                   ModoVideo
                   Draw_Axis
                   Check_Function
                   pressKey           ;Press a key to continue
                   ModoTexto          ;back to text mode
endm

;----------------------------------------------------------------------------------------
; Guardar el coeficiente como numero y no como ascii
;----------------------------------------------------------------------------------------
convertNumber macro var
                  xor bl,bl
                  mov bl, var[1]
                  sub bl, 48
                  mov var[1], bl
endm

AsciiToNumber MACRO
                  convertNumber coef4
                  convertNumber coef3
                  convertNumber coef2
                  convertNumber coef1
                  convertNumber coef0
ENDM

ModoVideo macro
    ;resolucion de 320x180
              mov ax, 0013h
              int 10h
    ;mov ax, 0A000h
    ;mov ds, ax        ; DS = A000h (memoria de graficos).
endm

;----------------------------------------------------------------------------------------
; Dibuja los ejes X y Y
;----------------------------------------------------------------------------------------
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

;----------------------------------------------------------------------------------------
; Draw a pixel in the graphic mode, (0,0) is in the top left corner
;----------------------------------------------------------------------------------------
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

;----------------------------------------------------------------------------------------
; Verifica el grado al que se hara la grafica
;----------------------------------------------------------------------------------------
Check_Function macro
                   LOCAL       isFourthGrade, isCubic, isCuadratic, isLineal, isConstant, finish
                   cmp         coef4[1], 0
                   jne         isFourthGrade
                   cmp         coef3[1], 0
                   jne         isCubic
                   cmp         coef2[1], 0
                   jne         isCuadratic
                   cmp         coef1[1], 0
                   jne         isLineal
                   cmp         coef0[0], 0
                   jne         isConstant
                   jmp         finish

    isFourthGrade: 
                   fourthGrade
                   jmp         finish
    isCubic:       
    ;thirdGrade  coef3,coef2,coef1,coef0
                   jmp         finish
    isCuadratic:   
    ;cuadratic   coef2, coef1, coef0
                   jmp         finish
    isLineal:      
    ;lineal      coef1, coef0
                   jmp         finish
    isConstant:    
    ;constant    coef0
                   jmp         finish
    finish:        

endm

;----------------------------------------------------------------------------------------
;   DIBUJAR DE GRADO 4
;----------------------------------------------------------------------------------------
fourthGrade macro
                LOCAL      while, is_negative, is_positive, continue, finish
                xor        ax, ax
                xor        bx, bx
                xor        cx, cx                                               ;cl = intervaloI | ch = intertervaloF
                mov        cl, var_intervaloI[1]
                mov        ch, var_intervaloF[1]

    while:      
                xor        ax, ax
                mov        bl, 160                                              ;x
                mov        dl, 100                                              ;y (160,100) - (0,0)
    ;checkSign
                test       cl,cl
                js         is_negative
                jmp        is_positive
    ;---------------Axis x----------------
    is_negative:
                neg        cl
                sub        bl, cl                                               ;where x start
    ;y
                cascadaX4
                neg        cl
                jmp        continue
    is_positive:
                mul        cl
                add        bl, cl
                cascadaX4
    ;-------------Axis y-------------------
    continue:   
    ;Draw
                Draw_Pixel bx, dx, 0ch
                inc        cl
                cmp        cl, ch
                jg         finish
                jmp        while
    finish:     
endm

cascadaX4 macro
                 LOCAL        coefficient3, coefficient2, coefficient1, coefficient0, minus4,minus3,minus2,minus1,minus, fin
    ;Coefficient 4
                 cmp          cl, 10
                 jg           fin

                 cmp          coef4[0], 45
                 je           minus4
    ;x^4
                 pushExceptAX
                 xor          ch, ch
                 potencia     4, cx
                 popExceptAx
    ;------------------c4 * x^4----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef4[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor          dx, dx
                 mov          cx, 500
                 div          cx
                 popExceptAx
    ;----------------real value---------------
                 sub          dx, ax
                 jmp          coefficient3
    minus4:      
    ;------------------x^4--------------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     4, cx
                 popExceptAx
    ;-----------------c4 * x^4----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef4[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd----------------
                 push         cx
                 mov          cx, 500
                 div          cx
                 pop          cx
    ;----------------real value---------------
                 add          dx, ax
    coefficient3:
                 cmp          coef3[0], 45
                 je           minus3
    ;----------------x^3---------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     3, cx
                 popExceptAx
    ;------------------c3 * x^3----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef3[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor          dx, dx
                 mov          cx, 500
                 div          cx
                 popExceptAx
    ;----------------real value---------------
                 sub          dx, ax
                 jmp          coefficient2
    minus3:      
    ;------------------x^3--------------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     3, cx
                 popExceptAx
    ;-----------------c3 * x^3----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef3[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd----------------
                 push         cx
                 mov          cx, 500
                 div          cx
                 pop          cx
    ;----------------real value---------------
                 add          dx, ax
    coefficient2:
                 cmp          coef2[0],45
                 je           minus2
    ;----------------x^2---------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     2, cx
                 popExceptAx
    ;------------------c2 * x^2----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef2[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor          dx, dx
                 mov          cx, 500
                 div          cx
                 popExceptAx
    ;----------------real value---------------
                 sub          dx, ax
                 jmp          coefficient1
    minus2:      
    ;------------------x^2--------------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     2, cx
                 popExceptAx
    ;-----------------c2 * x^2----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef2[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd----------------
                 push         cx
                 mov          cx, 500
                 div          cx
                 pop          cx
    ;----------------real value---------------
                 add          dx, ax
    coefficient1:
                 cmp          coef1[0], 45
                 je           minus1
    ;----------------x^1---------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     1, cx
                 popExceptAx
    ;------------------c1 * x^1----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef1[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd-----------------
                 pushExceptAX
                 xor          dx, dx
                 mov          cx, 500
                 div          cx
                 popExceptAx
    ;----------------real value---------------
                 sub          dx, ax
                 jmp          coefficient0
    minus1:      
    ;------------------x^1--------------------
                 pushExceptAX
                 xor          ch, ch
                 potencia     3, cx
                 popExceptAx
    ;-----------------c1 * x^1----------------
                 push         dx
                 xor          dx, dx
                 mov          dl, coef1[1]
                 mul          dx
                 pop          dx
    ;-----------------scale xd----------------
                 push         cx
                 mov          cx, 500
                 div          cx
                 pop          cx
    ;----------------real value---------------
                 add          dx, ax
    coefficient0:
                 cmp          coef0[0], 45
                 je           minus
                 push         cx
                 xor          ch, ch
                 mov          cl, coef0[1]
                 sub          dx, cx
                 pop          cx
                 jmp          fin
    minus:       
                 push         cx
                 xor          ch, ch
                 mov          cl, coef0[1]
                 add          dx, cx
                 pop          cx
    fin:         

endm

pushExceptAX macro
                 push bx
                 push cx
                 push dx
endm

popExceptAx macro
                pop dx
                pop cx
                pop bx
endm

potencia macro exponente, value
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

pressKey macro
             mov ah, 10h
             int 16h
endm

ModoTexto macro
              mov al, 0003h
              int 10h
endm