# Variables
## Exogenas

- Datos
  - IA : Intervalo entre arribos
  - CANT : Cantidad comprada por cliente
  - DE : Demora Entrega
- Control
  - SR : Stock Reposicion

## Endogenas

- Estado
  - ST : Stock
- Resultado
  - CT: Costo total

# Metodologia
Evento a evento

# Tabla de eventos independientes
| Evento     | EFNC  |    EFC     | Condicion |
| :--------- | :---: | :--------: | --------: |
| VENTA      | VENTA | REPOSICION |  ST <= SR |
| REPOSICION |   -   |     -      |         - |

# Tabla de eventos futuros
| TPLL | TPS[a] | TPS[b] |
| :--- | :----: | -----: |