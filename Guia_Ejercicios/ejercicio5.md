# Variables
## Exogenas

- Datos
  - IA
  - TA[a]
  - TA[b]
- Control
  - Implicita

## Endogenas

- Estado
  - NS[a]
  - NS[b]
- Resultado
  - PPS
  - PEC
  - PTO[a]
  - PTO[b]

# Metodologia
Evento a evento

# Tabla de eventos independientes
| Evento    |  EFNC   |    EFC    |                           Condicion |
| :-------- | :-----: | :-------: | ----------------------------------: |
| LLEGADA   | LLEGADA | SALIDA[a] |                           NS[a] = 1 |
|           |         | SALIDA[b] | NS[a] = 2 && NS[b] = 0 or NS[b] = 1 |
| SALIDA[a] |    -    | SALIDA[a] |                          NS[a] >= 1 |
| SALIDA[b] |    -    | SALIDA[b] |            NS[a] >= 2 or NS[b] >= 1 |

# Tabla de eventos futuros
| TPLL | TPS[a] | TPS[b] |
| :--- | :----: | -----: |

# Diagrama de flujo
::: mermaid
graph TD;
    CI[[C.I.]] --> A0{" TPLL <= TPS[a] "};
    1((1)) --> A0;
    subgraph Determinacion de Siguiente Evento
    A0 --> | Si | A1{" TPLL <= TPS[b] "};
    A0 --> | No | A2{" TPS[a] <= TPS[b] "};
    end
    A1 --> | Si | B1A["SPS = SPS + (TPLL - T) * (NS[a] + NS[b])"];
    A1 --> | No | D1["SPS = SPS + (TPS[b] - T) * (NS[a] + NS[b])"];
    A2 --> | Si | C1["SPS = SPS + (TPS[a] - T) * (NS[a] + NS[b])"];
    A2 --> | No | D1;

    subgraph LLEGADA
    B1A --> B1["T = TPLL"];
    B1 --> B2{{IA}};
    B2 --> B3["TPLL = TPLL + IA"];
    B3 --> B3A["NT = NT + 1"];
    B3A --> B4["random() --> r"];
        
        subgraph Seleccion de cola
        B4 --> B5{"r <= 0.35"};
        B5 --> | Si | BA1["NS[a] = NS[a] + 1"];
        B5 --> | No | BB1["NS[b] = NS[b] + 1"];
        end

        subgraph Cola A
        BA1 --> BA2{"NS[a] == 1"};
        BA2 --> | Si | BA3{{"TA[a]"}};
        BA2 --> | No | BA22{"NS[a] == 2 && NS[b] == 0"};
        BA22 --> | Si | BA222["NS[b] = NS[b] + 1"];
        BA222 --> BA2222["NS[a] = NS[a] - 1"];
        BA3 --> BA4["STO[a] = STO[a] + T - ITO[a]"];
        BA4 --> BA5["STA[a] = STA[a] + TA[a]"];
        BA5 --> BA6["TPS[a] = T + TA[a]"];
        end

        BA2222 --> BB3{{"TA[b]"}};

        subgraph Cola B
        BB1 --> BB2{"NS[b] = 1"};
        BB2 --> | Si | BB3{{"TA[b]"}};
        BB3 --> BB4["STO[b] = STO[b] + T - ITO[b]"];
        BB4 --> BB5["STA[b] = STA[b] + TA[b]"];
        BB5 --> BB6["TPS[b] = T + TA[b]"];
        end

    end
    BA22 --> | No | FIN{T < TF};
    BB2 --> | No | FIN;
    BA6 --> FIN;
    BB6 --> FIN;

    subgraph SALIDA A
    C1 --> C2["T = TPS[a]"];
    C2 --> C3["NS[a] = NS[a] - 1"];
    C3 --> C4{"NS[a] >= 1"};
    C4 --> | Si | C5{{"TA[a]"}};
    C5 --> C6["TPS[a] = T + TA[a]"];
    C4 --> | No | C7["ITO[a] = T"];
    C7 --> C8["TPS[a] = H.V."];
    end
    C6 --> FIN;
    C8 --> FIN;

    subgraph SALIDA B
    D1 --> D2["T = TPS[b]"];
    D2 --> D22["NS[b] = NS[b] - 1"];
    D22 --> D3{"NS[a] >= 2"};
    D3 --> | Si | D33["NS[a] = NS[a] - 1"];
    D33 --> D333["NS[b] = NS[b] + 1"];
    D333 --> D5{{"TA[b]"}};
    D5 --> D6["TPS[b] = T + TA[b]"];
    D3 --> | No | D8{"NS[b] >= 1"};
    D8 --> | Si | D5;
    D8 --> | No | D9["ITO[b] = T"];
    D9 --> D10["TPS[b] = H.V."];
    end
    D6 --> FIN;
    D10 --> FIN;

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
    F555 --> | Si | F5["PPS = STS / NT"];
    F5 --> F6["PTO[a] = STO[a] * 100 / T"];
    F6 --> F6B["PTO[b] = STO[b] * 100 / T"];
    F6B --> F7["PEC = (STS - STA) / N"];
    F7 --> F9[i = i + 1];
    F9 --> F555;
    F555 --> | No | F10[/IMPRIMIR RESULTADOS/];
    end
    
    end
:::