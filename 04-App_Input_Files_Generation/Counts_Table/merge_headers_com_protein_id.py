# Obter um ficheiro com as colunas Cluster, Cluster_original, Protein para poder juntar ao ficheiro de contagens

import pandas as pd

# 1. Ler os ficheiros
file1 = "filter_cluster_and_protein_id.csv"
file2 = "normalized_and_merged_orfs_headers.csv"

df1 = pd.read_csv(file1)  # Contém Cluster_norm, Cluster
df2 = pd.read_csv(file2)  # Contém query_id, Ncbi-Nr_Blast-p

# 2. Renomear colunas para poder fazer merge corretamente
df2 = df2.rename(columns={
    "query_id": "Cluster",
    "Ncbi-Nr_Blast-p": "Protein"
})

# 3. Merge (left join para manter todas as linhas de df1)
merged_df = pd.merge(df1, df2, on="Cluster", how="left")

# 4. Renomear colunas para formato final
merged_df.rename(columns={
    "Cluster": "Cluster_original",   # Cluster original (com .p1, .p2...)
    "Cluster_norm": "Cluster"        # Cluster normalizado
}, inplace=True)

# 5. Guardar num novo ficheiro CSV
output_file = "final_merged_headers_com_protein_id.csv"
merged_df.to_csv(output_file, index=False)

print(f"Novo ficheiro criado: {output_file}")
