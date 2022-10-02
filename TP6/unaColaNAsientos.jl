using CSV
using DataFrames
using Plotly

const HV = Inf64

inversaIA(x) = 10 * x
inversaTA(x) = 60+(240-60)*x

generarIA() = inversaIA(rand())
generarTA() = inversaTA(rand())

resultados = DataFrame(N = Int64[], PEC = Float64[])

# Condiciones iniciales
for N in 10:40

    t = 0
    tf = 100000

    ns = 0
    nc = 0
    nt = 0
    tpll = 0
    tps = fill(HV, N)

    ia = 0
    ta = 0

    SEC = 0
    PEC = 0
    
    while true
        i = findmin(tps)[2]
        if tpll <= tps[i]
            SEC += (tpll - t) * nc
            t = tpll
            tpll = t + generarIA()
            ns += 1
            nt += 1
            if ns <= N
                s = findmax(tps)[2]
                tps[s] = t + generarTA()
            else
                nc += 1
            end
        else
            SEC += (tps[i] - t) * nc
            t = tps[i]
            ns -= 1
            if ns >= N
                nc -= 1
                tps[i] = t + generarTA()
            else
                tps[i] = HV
            end
        end
        t < tf || break
    end

    PEC = SEC / nt
    push!(resultados, (N, PEC))
end

CSV.write("resultados.csv", resultados)