# Variables
## Exogenas

- Datos
  - IA
  - TA
- Control
  - Implicita

## Endogenas

- Estado
  - NS[n]
- Resultado
  - PPS[n]
  - PEC[n]
  - PTO[n]
  - PPA[n]

# Metodologia
Evento a evento

# Tabla de eventos independientes
| Evento    |  EFNC   |    EFC    | Condicion |
| :-------- | :-----: | :-------: | --------: |
| LLEGADA   | LLEGADA | SALIDA[n] | NS[n] = 1 |
| SALIDA[n] |    -    | SALIDA[n] | NS[n] > 0 |

# Tabla de eventos futuros
| TPLL | TPS[n] |
| :--- | :----: |

# Diagrama de flujo
::: mermaid
graph TD;
    CI[[C.I.]] --> A0[" TPE = Min(TEF) "];
    1((1)) --> A0;
    A0 --> A1{ TPE = TPLL };
    A1 --> | Si | B1[T = TPLL];
    A1 --> | No | A2[c = 0];
    A2 --> A3{"TPE = TPS[c]"};
    A3 --> | Si | C0["T = TPS[c]"];
    A3 --> | No | A4[c = c + 1];
    A4 --> A3;

    subgraph LLEGADA
    B1 --> B2{{IA}};
    B2 --> B3[TPLL = TPLL + IA];
    B3 --> B4[i = 1 <br> c = 0];
        subgraph Seleccion de cola
        B4 --> B5{i < n};
        B5 --> | Si | B6{"NS[i] <= NS[c]"};
        B6 --> | Si | B7["c = i"];
        B7 --> B8[i = i + 1];
        B6 --> | No | B8;
        B8 --> B5;
        end

    B5 --> | No | B9{"NS[c] > 8"};

        subgraph Arrepentimiento
        B9 --> | Si | B10[ARR = ARR + 1];
        B9 --> | No | B11{"NS[c] <= 5"};
        B11 --> | No | B13{{"random(r)"}};
        B13 --> B14{"r <= 0.2"};
        end

    B11 --> | Si | B12["STLL[c] = STLL[c] + 1"];
    B14 --> | Si | B12;
    B14 --> | No | B10;
    B12 --> B15["NS[c] = NS[c] + 1"];
    B15 --> B16["NT[c] = NT[c] + 1"];
    B16 --> B17{"NS[c] == 1"};
    B17 --> | Si | B18["STO[c] = STO[c] + T - ITO[c]"];
    B18 --> B19{{TA}};
    B19 --> B20["STA[c] = STA[c] + T"];
    B20 --> B21["TPS[c] = T + TA"];
    end
    B21 --> FIN{T < TF};
    B17 --> | No | FIN;
    B10 --> FIN;

    subgraph "SALIDA[c]"
    C0 --> C1["STS[c] = STS[c] + T"];
    C1 --> C2["NS[c] = NS[c] - 1"];
    C2 --> C3{"NS[c] > 0"};
    C3 --> | Si | C4{{TA}};
    C4 --> C5["STA[c] = STA[c] + TA"];
    C5 --> C6["TPS[c] = T + TA"];
    C3 --> | No | C7["ITO[c] = T"];
    C7 --> C8["TPS[c] = H.V."];
    end
    C6 --> FIN;
    C8 --> FIN;

    subgraph FINAL
    FIN --> | Si | F1((1));
    FIN --> | No | F2{"Sum(NS[i]) == 0" <br> 0 < i < n};

    subgraph Vaciamiento
    F2 --> | No | F3[TPLL = H.V.];
    F3 --> F4((1));
    end

    F2 --> | Si | F55[i = 0];

    subgraph Mostrar resultados
    F55 --> F555{i < n};
    F555 --> | Si | F5["PPS[i] = (STS[i] - STLL[i]) / NT[i]"];
    F5 --> F6["PTO[i] = STO[i] * 100 / T"];
    F6 --> F7["PEC[i] = (STS[i] - STLL[i] - STA[i])/ N"];
    F7 --> F8["PPA[i] = ARR[i] * 100 / (NT[i] + ARR[i])"];
    F8 --> F9[i = i + 1];
    F9 --> F555;
    F555 --> | No | F10[/IMPRIMIR RESULTADOS/];
    end
    
    end
:::