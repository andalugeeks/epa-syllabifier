# Auditoría lingüística inicial

## Alcance

`epa-syllabifier` separa sílabas sin transcribir castellano a EPA ni validar si
la ortografía recibida pertenece a EPA. El análisis debe ser tolerante con
préstamos, grafías heredadas y caracteres desconocidos. `syllabify()` procesa
una única unidad de palabra; `hyphenate()` admite texto completo.

## Fuentes

- [Propuesta EPA de ortografía andaluza de 2019][epa-pdf].
- [Página de presentación de EPA][epa-page].
- [`andalugeeks/andaluh-py`][andaluh-py], transcriptor mantenido por la misma
  organización. Su lemario sirve como fuente de ejemplos, pero no contiene
  fronteras silábicas.

## Reglas verificadas

La propuesta EPA publicada permite establecer esta base:

| Área | Regla documentada |
| --- | --- |
| Grafemas vocálicos | `a`, `e`, `i`, `o`, `u` y sus variantes con circunflejo |
| Circunflejo | `â`, `ê`, `î`, `ô`, `û` indican apertura o aspiración |
| Acento agudo | `á`, `é`, `í`, `ó`, `ú` indican vocal tónica |
| Acento grave | `à`, `è`, `ì`, `ò`, `ù` pueden cumplir función diacrítica |
| `ç` | Representa la solución integradora para realizaciones seseantes, ceceantes, distinguidoras y heheantes |
| `h` | Siempre se pronuncia; representa `/h/` o `/x/` según la variante |
| `x` | Representa realizaciones correspondientes al dígrafo castellano `ch` |
| Fonema `/k/` | Se escribe `c` ante `a`, `â`, `o`, `ô`, `u`, `û`; se escribe `qu` ante `e`, `ê`, `i`, `î` |
| Geminación | Una consonante posterior a una vocal abierta o aspirada se duplica |
| Doble `l` | Se escribe `l-l` para evitar confusión con el dígrafo castellano `ll` |

## Cobertura actual

El algoritmo implementa una primera heurística útil:

- Agrupa `qu`, `rr`, ataques consonánticos y secuencias consonante-vocal.
- Trata `n`, `h`, `r` y `m` en posición de coda.
- Reparte consonantes geminadas entre la coda de una sílaba y el ataque de la
  siguiente: `âtta` se separa como `ât-ta`.
- Normaliza mayúsculas y espacios exteriores.
- Admite guiones ortográficos interiores, como en `l-l`.
- Acepta las vocales con acento agudo, circunflejo y grave.
- Agrupa diptongos y triptongos; mantiene como hiato las secuencias con una
  vocal cerrada acentuada.
- Intenta silabificar préstamos y grafías no canónicas sin rechazarlos.
- Ofrece listas de sílabas con `syllabify()` y texto separado por guiones con
  `hyphenate()`, preservando puntuación, espacios y saltos de línea.

Los tests exhaustivos garantizan que las combinaciones cortas del alfabeto
admitido no producen excepciones, no pierden caracteres y no generan sílabas
vacías. Esto comprueba estabilidad técnica, no corrección lingüística.

## Decisiones adoptadas

### Secuencias vocálicas

Las vocales cerradas átonas pueden formar diptongos con otra vocal y
triptongos con el patrón cerrada-abierta-cerrada. Una vocal cerrada con acento
agudo rompe el agrupamiento y forma hiato.

| Entrada | Separación adoptada |
| --- | --- |
| `aire` | `ai-re` |
| `causa` | `cau-sa` |
| `peine` | `pei-ne` |
| `ciudá` | `ciu-dá` |
| `cuidao` | `cui-da-o` |
| `guau` | `guau` |
| `día` | `dí-a` |
| `tío` | `tí-o` |

### Validación ortográfica

El silabificador no rechaza grafías no canónicas. Por ejemplo, puede procesar
préstamos con `w` o caracteres desconocidos. Su responsabilidad es intentar
separar una unidad de palabra, no certificar su pertenencia a EPA.

### Guiones interiores

EPA emplea `l-l` para representar la doble `l`. El análisis elimina ese guion
ortográfico durante el cálculo para poder repartir la geminación correctamente.
`syllabify("ponêl-lo")` devuelve `["po", "nêl", "lo"]` y
`hyphenate("ponêl-lo")` devuelve `"po-nêl-lo"`, con las fronteras silábicas
representadas como guiones.

### Texto completo

`syllabify()` conserva su contrato de una sola unidad de palabra y devuelve una
lista de sílabas. `hyphenate()` recorre texto completo y conserva separadores
como puntuación, espacios y saltos de línea. Por ejemplo,
`hyphenate("¡Andalûh EPA!")` devuelve `"¡an-da-lûh e-pa!"`.

## Ampliación del corpus

El corpus actual contiene 58 palabras. El lemario de `andaluh-py` contiene
más de 86 000 transliteraciones y puede utilizarse para seleccionar candidatos
representativos. Como no incluye fronteras silábicas, cada incorporación al
corpus debe revisarse antes de convertirse en un resultado esperado.

[epa-pdf]: https://andaluhepa.files.wordpress.com/2019/10/propuesta-de-ortografc3ada-andaluza-epa-actualizada-2019-docx.pdf
[epa-page]: https://andaluh.es/epa-2/
[andaluh-py]: https://github.com/andalugeeks/andaluh-py
