using CSV
using DataFrames
using Plotly
using SpecialFunctions

# N Bancos individuales y M mesas

const HV = Inf64
const chanceMesa = 0.8

inversaIA(x) = -log(1 - x) / 0.1364
inversaTA(x) = exp(4.8975 + 0.42846 * sqrt(2) * erfinv(2 * x - 1))

generarIA() = inversaIA(rand())
generarTA() = inversaTA(rand())

resultados = DataFrame(N = Int64[], M = Int64[], PEC_Banco = Float64[], PEC_Mesa = Float64[])

contador = 0

for (N, M) in [(4, 14), (6, 21), (8, 28)]
    for iteraciones in 1:10 # Cantidad de simulaciones para cada caso
        t = 0
        tf = 100000

        nsBanco = 0
        nsMesa = 0
        ncBanco = 0
        ncMesa = 0
        ntBanco = 0
        ntMesa = 0
        tpll = 0
        tpsBanco = fill(HV, N)
        tpsMesa = fill(HV, M)

        ia = 0
        ta = 0

        SECBanco = 0
        SECMesa = 0
        PECBancos = 0
        PECMesas = 0

        while true
            i = findmin(tpsMesa)[2]
            j = findmin(tpsBanco)[2]
            proximoEvento = findmin([tpll, tpsMesa[i], tpsBanco[j]])[1]

            if tpll == proximoEvento
                SECBanco += (tpll - t) * ncBanco
                SECMesa += (tpll - t) * ncMesa
                t = tpll
                tpll = t + generarIA()

                if rand() < chanceMesa
                    nsMesa += 1
                    ntMesa += 1
                    if nsMesa <= M
                        s = findmax(tpsMesa)[2]
                        tpsMesa[s] = t + generarTA()
                    else
                        ncMesa += 1
                    end
                else
                    nsBanco += 1
                    ntBanco += 1
                    if nsBanco <= N
                        s = findmax(tpsBanco)[2]
                        tpsBanco[s] = t + generarTA()
                    else
                        ncBanco += 1
                    end
                end
            elseif tpsMesa[i] == proximoEvento
                SECBanco += (tpsMesa[i] - t) * ncBanco
                SECMesa += (tpsMesa[i] - t) * ncMesa
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
                t = tpsBanco[j]
                nsBanco -= 1
                if nsBanco >= N
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
        push!(resultados, (N, M, PECBanco, PECMesa))
        global contador += 1
        println(contador)
    end
end

CSV.write("resultados.csv", resultados)