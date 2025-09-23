# Ficheiro de anotações com informação sobre eggnog, go, kegg_Pathways
# Normalizar os nomes dos clusters para ficar padronizado 

import pandas as pd
import re

# 1. Lê o ficheiro XLSX
df = pd.read_excel("eggnog_final_anotado.xlsx")  

# 2. Se a coluna que contém os clusters se chama 'Cluster', renomeia para 'gene'
if 'Cluster' in df.columns:
    df = df.rename(columns={'Cluster': 'gene'})

# 3. Função para converter IDs
def converter_id(gene_id):
    match = re.match(r"(Cluster)_(\d+)_([0-9]+)\.p[0-9]+", str(gene_id))
    if match:
        cluster, numero, sub = match.groups()
        return f"{cluster}-{numero}.{sub}"
    return gene_id

# 4. Aplica a conversão à coluna 'gene'
df['gene'] = df['gene'].apply(converter_id)

# 5. Salva de volta para XLSX 
df.to_excel("anotacoes_convertidas.xlsx", index=False)
# df.to_csv("anotacoes_convertidas.csv", sep='\t', index=False)

print("Conversão concluída com sucesso!")



