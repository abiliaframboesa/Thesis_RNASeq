# Juntar ao ficheiro de contagens vindo do Corset a coluna de Protein que identifica o Cluster.
# Além disso, filtrar os clusters de forma que em vez de aparecerem os clusters provenientes do Transcriptoma V0, 
# apareçam os clusters que codificam para ORFs (transcriptoma V1). Desta forma só se vai fazer a análise de 
# expressão diferencial para clusters que codificam orfs.

import pandas as pd

# 1. Ler counts.txt e renomear a primeira coluna para Cluster
counts = pd.read_csv("counts.txt", sep="\t")
counts = counts.rename(columns={counts.columns[0]: "Cluster"})

# 2. Ler o ficheiro final_merged_headers_com_protein_id.csv
final_merged = pd.read_csv("final_merged_headers_com_protein_id.csv")

# 3. Selecionar apenas Cluster e Protein
final_merged = final_merged[["Cluster", "Protein"]]

# 4. Merge (inner join) para manter apenas clusters presentes no final_merged
merged = pd.merge(final_merged, counts, on="Cluster", how="inner")

# 5. Reorganizar colunas: Cluster, Protein, depois colunas de counts
cols = ["Cluster", "Protein"] + [c for c in counts.columns if c != "Cluster"]
merged = merged[cols]

# 6. Guardar resultado em TXT separado por tabulação
output_file = "counts_with_proteinID.txt"
merged.to_csv(output_file, sep="\t", index=False)

print(f"Novo ficheiro TXT criado: {output_file}")
