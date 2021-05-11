using JuMP
using GLPK
using LinearAlgebra

function daj_izvor(C)
    for j in 1:size(C)[2]
        sveNule = true
        for i in 1:size(C)[1]
            if C[i, j] != 0
                sveNule = false
                break
            end
        end
        if sveNule
            return j
        end
    end
end

function protokLP(C)
    m = Model(GLPK.Optimizer)
    izvor = daj_izvor(C)
    ponor = daj_izvor(transpose(C))

    @variable(m, 0 <= x[i=1:size(C)[1], j=1:size(C)[2]; C[i,j] != 0] <= C[i, j], Int)

    @expression(m, ex, sum(x[izvor,j] for j in 1:size(C)[1] if C[izvor, j] != 0))
    @objective(m, Max, ex)

    for i in 1:size(C)[1]
        if (i == izvor) || (i == ponor)
            continue
        end
        temp = @expression(m, sum(x[i, j] for j in 1:size(C)[2] if C[i, j] != 0))
        tempMinus = @expression(m, sum(x[j, i] for j in 1:size(C)[1] if C[j, i] != 0))
        @constraint(m, temp - tempMinus == 0)
    end

    optimize!(m)

    matrica = zeros(size(C)[1], size(C)[1])
    for i in 1:size(matrica)[1]
        for j in 1:size(matrica)[2]
            if C[i,j] != 0
                matrica[i, j] = value(x[i, j])
            end
        end
    end

    return matrica, objective_value(m)
end

function ispisi(m)
    for i in 1:size(m)[1]
        println(m[i, :])
    end
end

C=[0 3 0 3 0 0 0 0;0 0 4 0 0 0 0 0;0 0 0 1 2 0 0 0;0 0 0 0 2 6 0 0;0 1 0 0 0 0 0 1;0 0 0 0 2 0 9 0;0 0 0 0 3 0 0 5;0 0 0 0 0 0 0 0];
X,V = protokLP(C)
