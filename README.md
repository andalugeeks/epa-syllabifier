# EPA Syllabifier

Módulo Python para la silabificación de palabras.

## Uso

```python
>>> from epa_syllabifier import syllabify
>>> syllabify("arcançía")
['ar', 'can', 'çía']
```

`syllabify()` procesa una única palabra EPA. La función normaliza las
mayúsculas y los espacios exteriores. También admite guiones interiores,
que se eliminan antes de aplicar las reglas de silabificación. Las frases,
los números, la puntuación y los caracteres ajenos al alfabeto EPA producen
un error `ValueError`.

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

## Requisitos

- Python >= 3.10

## Licencia

Este proyecto está licenciado bajo la Licencia GPL v3 - ver el archivo [LICENSE](LICENSE) para más detalles.
