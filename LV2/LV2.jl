using Pkg
Pkg.add("Plots")
using Plots
using LinearAlgebra

#1. zadatak

function saberi_i_oduzmi(a=nothing, b=nothing)
  if(a == nothing)
    a = 0
  end

  if(b == nothing)
    b = 0
  end

  if(size(a) != size(b))
    return 0, 0
  end

  return a+b, a-b
end

#2. zadatak

function saberi(matrica)

  suma_po_redovima = zeros(size(matrica, 1))
  suma_po_kolonama = zeros(size(matrica, 2))
  ukupna_suma = 0
  suma_glavna_dijagonala = 0
  suma_sporedna_dijagonala = 0

  for i in 1:size(matrica, 1)
    for j in 1:size(matrica, 2)
      suma_po_redovima[i] += matrica[i,j]
      suma_po_kolonama[j] += matrica[i,j]
      ukupna_suma += matrica[i,j]

      if i == j
        suma_glavna_dijagonala += matrica[i,j]
      end

      if i+j == size(matrica, 2)+1
        suma_sporedna_dijagonala += matrica[i,j]
      end
    end
  end

  return ukupna_suma, suma_po_redovima, suma_po_kolonama, suma_glavna_dijagonala, suma_sporedna_dijagonala

end

#3. zadatak

function crtaj(izraz)
  global x = collect(LinRange(-5, 5, 100))

  y = eval(Meta.parse(izraz))

  plot(x,y)
end
