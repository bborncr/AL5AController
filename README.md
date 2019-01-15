# AL5AController
El AL5A es un brazo robótico fabricado por Lynxmotion en los EEUU.

Tarjeta de Control: BotBoarduino (el bootloader es el Arduino Duemilanove)

Manuales, esquemáticos y código de ejemplo del fabricante se puede conseguir en el siguiente enlace: 
[Documentacion Oficial del fabricante](https://www.robotshop.com/en/lynxmotion-botboarduino-robot-controller.html)
## Software
En 2013 CRCibernética hizo un software de control básico basado en Processing.

[AL5A_Driver](https://github.com/bborncr/AL5A_Driver) es un firmware simple para controlar los 5 servos del brazo via comandos seriales. Seleccionar Duemilanove en el Arduino IDE. La velocidad del interfaz serial es 57600.

El driver controla los 5 servomotores:
- Servo 0 Base
- Servo 1 Hombro
- Servo 2 Codo
- Servo 3 Muñeca
- Servo 4 Garra

AL5AController es una aplicación desarrollada en Processing 3 (probado con v3.3.7)

Requisitos: 
- Processing 3.3.7+
- Librerias: G4P
- Tools: G4P GUI Builder

El GUI permite el control de cada servo en forma individual.
El interfaz X/Y controla la distancia en milímetros desde el eje del servo en el base hasta el eje del servo en la muñeca. El interfaz X/Y es un ejemplo de cinemática inversa. Los valores de X/Y están convertidos en las posiciones de servos 1, 2 y 3. Hay una curva de aceleración asociado con cada servo para suavizar los movimientos.

### Grabación y Reproducción de movimientos
La aplicación permite grabar y reproducir secuencias de movimiento. Los archivos de las secuencias se encuentran el folder “Data” dentro del folder del Sketch (CTRL+K para abrir el folder). 

Comandos:

Secuencia para grabar posiciones:
- N - Empezar una nueva secuencia (genera un archivo nuevo)
- S - Grabar una posición. La velocidad de reproducción por defecto es 1 posicion cada 100 mS
- X - Guardar y cerrar el archivo actual

Secuencia para grabar posiciones cada 100mS:
- N - Empezar una nueva secuencia (genera un archivo nuevo)
- R - Empezar a grabar una posición cada 100 mS
- X - Guardar y cerrar el archivo actual

Secuencia para reproducir los movimientos:
- O - Abre una ventana para seleccionar el archivo de posiciones
- P - Reproducir el archivo seleccionado

