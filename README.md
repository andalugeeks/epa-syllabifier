# EPA Syllabifier

Módulo Python para la silabificación de palabras y textos.

## Uso

```python
>>> from epa_syllabifier import hyphenate, syllabify
>>> syllabify("arcançía")
['ar', 'can', 'çí', 'a']
>>> hyphenate("¡Andalûh EPA!")
'¡an-da-lûh e-pa!'
```

`syllabify()` procesa una única unidad de palabra y devuelve sus sílabas como
lista. `hyphenate()` procesa texto completo y devuelve las fronteras silábicas
calculadas como guiones, conservando la puntuación, los espacios y los saltos
de línea. Las funciones normalizan las mayúsculas de las palabras analizadas.
También admiten guiones ortográficos interiores, como en `l-l`.

La librería no valida si la grafía recibida pertenece al estándar EPA:
silabifica de forma tolerante préstamos, grafías heredadas y caracteres
desconocidos. `syllabify()` produce un error `ValueError` con frases o entradas
con espacios interiores; para procesar más de una palabra se utiliza
`hyphenate()`.

### Prueba manual

Para revisar palabras una a una desde la terminal:

```bash
make try
```

Escribe una palabra EPA y pulsa Intro. El comando devuelve las sílabas
separadas por guiones y queda esperando la siguiente palabra. Pulsa Intro sin
escribir texto para salir.

## Desarrollo

### Instalación para desarrollo

Para contribuir al proyecto, primero clona el repositorio y luego instala las dependencias de desarrollo:

```bash
git clone https://github.com/andalugeeks/epa-syllabifier.git
cd epa-syllabifier

# Configuración completa de desarrollo (crea venv e instala dependencias)
make dev-setup

# Ver comando para activar el entorno virtual
make activate
```

### Ejecución de tests

Para ejecutar los tests:

```bash
# Ejecutar todos los tests
make test

# Ejecutar tests con cobertura
make test-coverage

# Ejecutar tests con salida detallada
make test-verbose

# Ejecutar tests
make quick-test

# Ejecutar únicamente el barrido exhaustivo de propiedades
make test-properties
```

`make quick-test` omite el barrido exhaustivo para facilitar iteraciones rápidas.
El resto de objetivos de test incluye las propiedades permanentes del
silabificador: toda combinación de hasta cuatro caracteres EPA debe procesarse
sin excepciones, sin sílabas vacías y sin perder caracteres.

### CI local

Antes de guardar un checkpoint relevante en Git, ejecuta:

```bash
make ci-local
```

Este comando limpia artefactos temporales, comprueba espacios sobrantes y
formato, ejecuta cobertura, prueba la suite con Python 3.10, 3.11, 3.12 y 3.13,
y construye la distribución. La ejecución utiliza
[`uv`](https://docs.astral.sh/uv/), que instala entornos aislados cuando son
necesarios.

### Comandos útiles de desarrollo

```bash
# Ver todos los comandos disponibles
make help

# Formatear código con Black
make format

# Verificar formato del código
make lint

# Construir el paquete
make build

# Limpiar archivos temporales
make clean

# Configuración completa: limpieza + instalación + tests
make all
```

### Revisión lingüística

La [auditoría lingüística inicial](docs/linguistic-review.md) recoge las fuentes
EPA utilizadas, las reglas ya cubiertas y las decisiones pendientes antes de
ampliar el algoritmo.

## Requisitos

- Python >= 3.10

## Licencia

Este proyecto está licenciado bajo la Licencia GPL v3 - ver el archivo [LICENSE](LICENSE) para más detalles.
