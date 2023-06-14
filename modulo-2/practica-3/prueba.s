.data
msj: .asciiz "Ingrese un numero: " ; El mensaje a mostrar
cero: .asciiz "cero"
uno: .asciiz "uno"
dos: .asciiz "dos"
tres: .asciiz "tres"

CONTROL: .word32 0x10000
DATA: .word32 0x10008

  .text
lwu $s0, CONTROL(r0)
lwu $s1, DATA(r0)
jal ingreso
beqz $v0, NotANumber
daddui $a0, $v0, 0
jal muestra

NotANumber: halt

ingreso: daddi $t0, $0, 6 ; funcion 6 (limpiar pantalla)
  sd $t0, 0($s0) ; se ejecuta

  daddi $t1, $0, msj ; obtengo en $t1 direccion del mensaje a mostrar
  sd $t1, 0($s1) ; almaceno direccion en DATA
  daddi $t0, $0, 4 ; funcion 4 (salida de cadena ASCII)
  sd $t0, 0($s0) ; se ejecuta

  daddi $t0, $0, 9 ; funcion 9 (entrada de ASCII en DATA)
  sd $t0, 0($s0) ; se ejecuta
  
  daddi $v0, $0, 0 ; por defecto retorna 0 (numero invalido)

  ; se corrobora si el valor almacenado en $s0 (DATA) es un digito
  ld $t0, 0($s1) ; almaceno en $t0 el valor
  slti $t1, $t0, 48
  bnez $t1, fin ; analizo si es mayor a numeros en ASCII
  slti $t1, $t0, 57
  beqz $t1, fin ; analizo si es menor a numeros 
  daddui $t0, $t0, -48
  daddi $v0, $t0, 0 ; retorno el numero si es valido
  fin: jr r31

muestra: daddui $t0, $a0, 48
  slti $t0, $a0, 1 ; si es menor que uno es cero
  daddi $t1, $0, cero ; recupero direccion del string "cero"
  bnez $t0, finMuestra
  slti $t0, $a0, 2 ; si es menor que dos es uno
  daddi $t1, $0, uno ; recupero direccion del string "uno"
  bnez $t0, finMuestra
  slti $t0, $a0, 3 ; si es menor que tres es dos
  daddi $t1, $0, dos ; recupero direccion del string "dos"
  bnez $t0, finMuestra
  slti $t0, $a0, 4 ; si es menor que cuatro es tres
  daddi $t1, $0, tres ; recupero direccion del string "tres"
  bnez $t0, finMuestra

  finMuestra: sd $t1, 0($s1) ; almaceno en DATA resultado final
  daddi $t0, $0, 4
  sd $t0, 0($s0)
  jr r31