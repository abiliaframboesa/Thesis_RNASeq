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


import pandas as pd
import re

input_csv = "orfs_headers.csv"
output_csv = "orfs_headers_normalizados.csv"

# Lê o CSV original
df = pd.read_csv(input_csv)

def normalizar_cluster(nome):
    # Usa regex para capturar Cluster, número e subnúmero
    match = re.match(r"(Cluster)_(\d+)_(\d+)\.p\d+", nome)
    if match:
        prefixo, numero, sub = match.groups()
        return f"{prefixo}-{numero}.{sub}"
    return nome  # fallback se não bater o padrão

df["Cluster"] = df["Cluster"].apply(normalizar_cluster)

df.to_csv(output_csv, index=False)

print(f"Clusters normalizados e salvos em: {output_csv}")
