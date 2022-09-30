# 1

## Variables
### Exogenas

- Datos
  - IA
  - TA[a]
  - TA[b]
- Control
  - Implicita

### Endogenas

- Estado
  - NS
- Resultado
  - PEC
  - PTO[a]
  - PTO[b]

## Metodologia
Evento a evento

## Tabla de eventos independientes
| Evento    |  EFNC   |    EFC    |        Condicion |
| :-------- | :-----: | :-------: | ---------------: |
| LLEGADA   | LLEGADA | SALIDA[a] |           NS = 3 |
|           |         | SALIDA[b] |           NS = 1 |
| SALIDA[a] |    -    | SALIDA[a] |          NS >= 3 |
| SALIDA[b] |    -    | SALIDA[b] | NS >= 3 v NS = 1 |

## Tabla de eventos futuros
| TPLL | TPS[a] | TPS[b] |
| :--- | :----: | -----: |

# 2

## Variables
### Exogenas

- Datos
  - IA
  - TA[a]
  - TA[b]
- Control
  - Implicita

### Endogenas

- Estado
  - NS
  - NC
- Resultado
  - PEC
  - PTO[a]
  - PTO[b]

## Metodologia
Evento a evento

## Tabla de eventos independientes
| Evento    |  EFNC   |    EFC    | Condicion |
| :-------- | :-----: | :-------: | --------: |
| LLEGADA   | LLEGADA | SALIDA[a] |    NS = 1 |
|           |         | SALIDA[b] |    NS = 8 |
| SALIDA[a] |    -    | SALIDA[a] |   NS >= 1 |
| SALIDA[b] |    -    | SALIDA[b] |   NS >= 8 |

## Tabla de eventos futuros
| TPLL | TPS[a] | TPS[b] |
| :--- | :----: | -----: |

# 3

## Variables
### Exogenas

- Datos
  - IA
  - TA[n]
  - TA[c]
- Control
  - n (nro de ayudantes)

### Endogenas

- Estado
  - NS
- Resultado
  - PPS
  - PTO[b]
  - PPD

## Metodologia
Evento a evento

## Tabla de eventos independientes
| Evento    |  EFNC   |    EFC    |  Condicion |
| :-------- | :-----: | :-------: | ---------: |
| LLEGADA   | LLEGADA | SALIDA[n] | NS[n] <= n |
| SALIDA[n] |    -    | SALIDA[a] |  NS[n] > n |

## Tabla de eventos futuros
| TPLL | TPS[a] |
| :--- | :----: |

# 4

## Variables
### Exogenas

- Datos
  - IA
  - TA
- Control
  - N[m]
  - N[f]
  - N[q]

### Endogenas

- Estado
  - TC[m]
  - TC[f]
  - TC[q]
- Resultado
  - PEC[m]
  - PEC[f]
  - PEC[q]

## Metodologia
Evento a evento

## Tabla de eventos independientes
| Evento  |  EFNC   |  EFC  | Condicion |
| :------ | :-----: | :---: | --------: |
| LLEGADA | LLEGADA |   -   |         - |

## Tabla de eventos futuros
| TPLL |
| :--- |
