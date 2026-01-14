# Snake_Assembler8086
# Snake en Assembly 8086

Implementación completa del clásico juego **Snake** desarrollada en **Assembly 8086**, ejecutándose en modo real y utilizando interrupciones BIOS/DOS para gráficos, entrada por teclado y control del flujo del programa.

## Descripción general

El proyecto consiste en un videojuego Snake programado desde cero, sin uso de librerías de alto nivel. El juego se ejecuta en **modo gráfico VGA 13h (320x200, 256 colores)** y gestiona directamente el hardware mediante interrupciones.

Incluye lógica completa de juego: movimiento continuo, detección de colisiones, crecimiento dinámico del snake, puntaje, generación de manzanas y aumento progresivo de la dificultad.

## Características principales

- Modo gráfico VGA 13h mediante `INT 10h`
- Lectura de teclado en tiempo real mediante `INT 16h`
- Renderizado píxel a píxel
- Movimiento continuo con control de dirección
- Crecimiento del snake al consumir manzanas
- Sistema de puntaje
- Incremento progresivo de dificultad (velocidad y color)
- Detección de colisiones con bordes
- Temporización manual mediante ciclos de delay
- Control explícito de registros y flujo de ejecución

## Controles

- **I** → Arriba  
- **K** → Abajo  
- **J** → Izquierda  
- **L** → Derecha  

## Aspectos técnicos destacados

- Uso intensivo de registros (AX, BX, CX, DX, SI, DI)
- Manejo manual de coordenadas X/Y
- Dibujo directo en memoria de video
- Implementación de lógica de estados para dirección y movimiento
- Validación de límites del área de juego
- Subrutinas para renderizado, limpieza de pantalla, delay y generación de manzanas

## Estructura del programa

- `main`  
  Inicialización del entorno, cambio de modo gráfico y loop principal.
- `borrar`  
  Limpieza de pantalla y renderizado del marco de juego.
- `manzana`  
  Dibujo de la manzana en pantalla.
- `delay`  
  Control de velocidad del juego mediante ciclos de espera.

## Requisitos

- Ensamblador compatible con **8086** (MASM / TASM)
- Emulador o entorno DOS (DOSBox recomendado)

## Ejecución

1. Ensamblar y linkear el código:
   ```bash
   masm snake.asm;
   link snake.obj;
