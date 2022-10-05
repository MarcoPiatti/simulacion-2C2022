using CSV
using DataFrames
using Plotly
using SpecialFunctions

# N Bancos individuales y M mesas
# 15% de la gente que llega viene sola
# 85% de la gente que llega viene en grupos
# Normalmente una persona llega, pregunta si hay lugar, y si no hay espera.
# (El hecho de preguntar si hay lugar hace que en el modelo ya se sepa que tipo de cupo espera la persona)

# Criterio de arrepentimiento: si hay tanta gente/grupos en cola como bancos/mesas disponibles, o más
# El criterio es anecdotico
# Considera que una persona en promedio esta dispuesta a esperar el mismo tiempo que va a pasar en el local
# Es necesario para no tener valores absurdos de PEC en casos de poca atención

const HV = Inf64
const chanceMesa = 0.85

inversaIA(x) = -log(1 - x) / 0.1364
inversaTA(x) = exp(4.8975 + 0.42846 * sqrt(2) * erfinv(2 * x - 1))

generarIA() = inversaIA(rand())
generarTA() = inversaTA(rand())

resultados = DataFrame(
        B = Int64[], 
        M = Int64[], 
        PEC_Banco = Float64[], 
        PEC_Mesa = Float64[], 
        ARR = Float64[], 
        PPTOB = Float64[],
        PPTOM = Float64[]
    )

progreso = 0
casosDeSimulacion = [(4 + div(i, 3), 14 + i) for i in 0:14]
iteracionesPorCaso = 1
totalSimulaciones = length(casosDeSimulacion) * iteracionesPorCaso

for (B, M) in casosDeSimulacion
    for iteracion in 1:iteracionesPorCaso # Cantidad de simulaciones para cada caso
        t = 0
        tf = 10000000

        nsBanco = 0
        nsMesa = 0
        ncBanco = 0
        ncMesa = 0
        ntBanco = 0
        ntMesa = 0
        tpll = 0
        tpsBanco = fill(HV, B)
        tpsMesa = fill(HV, M)

        ia = 0
        ta = 0

        SECBanco = 0
        SECMesa = 0
        PECBancos = 0
        PECMesas = 0

        PPA = 0
        ARR = 0

        STOB = 0
        STOM = 0
        PPTOB = 0
        PPTOB = 0

        while true
            i = findmin(tpsMesa)[2]
            j = findmin(tpsBanco)[2]
            proximoEvento = findmin([tpll, tpsMesa[i], tpsBanco[j]])[1]

            if tpll == proximoEvento
                SECBanco += (tpll - t) * ncBanco
                SECMesa += (tpll - t) * ncMesa
                bancosOciosos = count(x -> x == HV, tpsBanco)
                STOB += (tpll - t) * bancosOciosos
                mesasOciosas = count(x -> x == HV, tpsMesa)
                STOM += (tpll - t) * mesasOciosas

                t = tpll
                tpll = t + generarIA()

                if rand() < chanceMesa
                    if ncMesa < M
                        nsMesa += 1
                        ntMesa += 1
                        if nsMesa <= M
                            s = findmax(tpsMesa)[2]
                            tpsMesa[s] = t + generarTA()
                        else
                            ncMesa += 1
                        end
                    else
                        ARR+=1

                    end
                else
                    if ncBanco < B
                        nsBanco += 1
                        ntBanco += 1
                        if nsBanco <= B
                            s = findmax(tpsBanco)[2]
                            tpsBanco[s] = t + generarTA()
                        else
                            ncBanco += 1
                        end
                    else
                        ARR+=1
                    end
                end
            elseif tpsMesa[i] == proximoEvento
                SECBanco += (tpsMesa[i] - t) * ncBanco
                SECMesa += (tpsMesa[i] - t) * ncMesa
                bancosOciosos = count(x -> x == HV, tpsBanco)
                STOB += (tpsMesa[i] - t) * bancosOciosos
                mesasOciosas = count(x -> x == HV, tpsMesa)
                STOM += (tpsMesa[i] - t) * mesasOciosas

                t = tpsMesa[i]
                nsMesa -= 1
                if nsMesa >= M
                    ncMesa -= 1
                    tpsMesa[i] = t + generarTA()
                else
                    tpsMesa[i] = HV
                end
            elseif tpsBanco[j] == proximoEvento
                SECBanco += (tpsBanco[j] - t) * ncBanco
                SECMesa += (tpsBanco[j] - t) * ncMesa
                bancosOciosos = count(x -> x == HV, tpsBanco)
                STOB += (tpsBanco[j] - t) * bancosOciosos
                mesasOciosas = count(x -> x == HV, tpsMesa)
                STOM += (tpsBanco[j] - t) * mesasOciosas

                t = tpsBanco[j]
                nsBanco -= 1
                if nsBanco >= B
                    ncBanco -= 1
                    tpsBanco[j] = t + generarTA()
                else
                    tpsBanco[j] = HV
                end
            end
            t < tf || break
        end

        PECBanco = SECBanco / ntBanco
        PECMesa = SECMesa / ntMesa
        PPA = (ARR * 100) / (ntBanco + ntMesa)
        PPTOB = STOB * 100 / (t * B)
        PPTOM = STOM * 100 / (t * M)

        push!(resultados, (B, M, PECBanco, PECMesa, PPA, PPTOB, PPTOM))
        global progreso += 1
        println("Iteracion $progreso de $totalSimulaciones")
    end
end

CSV.write("resultados.csv", resultados)