# Normalizar Cluster_ids para ficarem no mesmo formato em todos os ficheiros 
# import pandas as pd

# df = pd.read_csv("clusters_summary.csv", sep="\t")
# print(df.columns.tolist())
import pandas as pd
import re

# Lê o ficheiro xlsx
df = pd.read_excel("eggnog_merged_anotado.xlsx")  

# Função para converter IDs
def converter_id(gene_id):
    match = re.match(r"(Cluster)_(\d+)_([0-9]+)\.p[0-9]+", str(gene_id))
    if match:
        cluster, numero, sub = match.groups()
        return f"{cluster}-{numero}.{sub}"
    return gene_id

# Aplica a conversão à coluna 'gene'
df['gene'] = df['gene'].apply(converter_id)

# Salva de volta para XLSX 
df.to_excel("anotacoes_normalizadas.xlsx", index=False)

print("Conversão concluída com sucesso!")
