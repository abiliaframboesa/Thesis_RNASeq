# Ficheiro de anotações com informação sobre eggnog, go, kegg_Pathways
# Normalizar os nomes dos clusters para ficar padronizado 

import pandas as pd
import re

# Lê o ficheiro XLSX 
df = pd.read_excel("eggnog_final_anotado.xlsx")  

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
df.to_excel("anotacoes_convertidas.xlsx", index=False)
# df.to_csv("anotacoes_convertidas.csv", sep='\t', index=False)

print("Conversão concluída com sucesso!")


