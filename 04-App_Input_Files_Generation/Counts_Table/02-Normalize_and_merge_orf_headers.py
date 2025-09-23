# Create a file with the columns: Cluster, Cluster_norm so that we can merge the Clusters info with Counts Table from Corset and with Protein ID from NCBI-nr.

import pandas as pd

# Ficheiro de input
input_csv = "orfs_headers.csv"

# Ficheiro de output
output_csv = "normalized_and_merged_orfs_headers.csv"

# Função para normalizar os nomes dos clusters
def normalize_cluster(name):
    """
    Exemplo: Cluster_49324_8.p1 -> Cluster-49324.8
    """
    # Remove "Cluster_" e ".pX"
    base = name.replace("Cluster_", "")
    base = base.split(".p")[0]  # remove o .p1, .p2...
    # Substitui underline do segundo número por ponto
    parts = base.split("_")
    if len(parts) == 2:
        return f"Cluster-{parts[0]}.{parts[1]}"
    return f"Cluster-{base}"

# Ler ficheiro
df = pd.read_csv(input_csv)

# Criar coluna com clusters normalizados
df["Cluster_norm"] = df["Cluster"].apply(normalize_cluster)

# Reordenar colunas para ficar como desejado
df = df[["Cluster_norm", "Cluster"]]

# Guardar ficheiro output
df.to_csv(output_csv, index=False)

# Mensagem de confirmação
print(f"Ficheiro {output_csv} criado com {len(df)} linhas e {df['Cluster_norm'].nunique()} clusters únicos.")
