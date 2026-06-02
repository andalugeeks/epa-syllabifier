# Auditoría lingüística inicial

## Alcance

`epa-syllabifier` separa una única unidad de palabra. No transcribe castellano
a EPA ni valida si la ortografía recibida pertenece a EPA. El análisis debe
ser tolerante con préstamos, grafías heredadas y caracteres desconocidos.

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
- Intenta silabificar préstamos y grafías no canónicas sin rechazarlos.
- Ofrece listas de sílabas con `syllabify()` y texto separado por guiones con
  `hyphenate()`.

Los tests exhaustivos garantizan que las combinaciones cortas del alfabeto
admitido no producen excepciones, no pierden caracteres y no generan sílabas
vacías. Esto comprueba estabilidad técnica, no corrección lingüística.

## Decisiones pendientes

### Secuencias vocálicas

La implementación solo agrupa automáticamente una vocal cerrada seguida de
una abierta. Antes de ampliar esta regla hay que confirmar los criterios EPA
para diptongos, triptongos e hiatos.

| Entrada | Resultado actual | Resultado esperado |
| --- | --- | --- |
| `aire` | `a-i-re` | Pendiente |
| `causa` | `ca-u-sa` | Pendiente |
| `peine` | `pe-i-ne` | Pendiente |
| `ciudá` | `ci-u-dá` | Pendiente |
| `cuidao` | `cu-i-da-o` | Pendiente |
| `guau` | `gua-u` | Pendiente |
| `día` | `día` | Pendiente |
| `tío` | `tío` | Pendiente |

## Decisiones adoptadas

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

## Ampliación del corpus

El corpus actual contiene 58 palabras. El lemario de `andaluh-py` contiene
más de 86 000 transliteraciones y puede utilizarse para seleccionar candidatos
representativos. Como no incluye fronteras silábicas, cada incorporación al
corpus debe revisarse antes de convertirse en un resultado esperado.

[epa-pdf]: https://andaluhepa.files.wordpress.com/2019/10/propuesta-de-ortografc3ada-andaluza-epa-actualizada-2019-docx.pdf
[epa-page]: https://andaluh.es/epa-2/
[andaluh-py]: https://github.com/andalugeeks/andaluh-py
