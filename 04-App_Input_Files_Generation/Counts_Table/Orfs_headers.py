# Selecionar apenas os nomes dos Clusters para os quais foram identificadas as ORFs.  

input_file = "longest_orfs_processed.pep"
output_file = "orfs_headers.csv"

with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    f_out.write("Cluster\n")  # Apenas uma coluna no CSV

    for line in f_in:
        line = line.strip()
        if line.startswith(">"):
            header = line[1:]  # remove ">"
            cluster = header.split()[0]  # pega só até o espaço (se houver)
            f_out.write(f"{cluster}\n")

print(f" Arquivo CSV criado: {output_file}")
