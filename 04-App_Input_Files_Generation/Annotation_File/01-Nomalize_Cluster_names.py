# Normalizar os nomes dos clusters para ficar padronizado com o resto dos nomes dos clusters

import pandas as pd
import re

# Lê o ficheiro XLSX ou CSV separado por tabulação
# Substitui 'arquivo.xlsx' pelo teu ficheiro
df = pd.read_excel("clusters_summary.xlsx")  # ou pd.read_csv("arquivo.csv", sep='\t')

# Função para converter IDs
def converter_id(gene_id):
    match = re.match(r"(Cluster)_(\d+)_([0-9]+)\.p[0-9]+", str(gene_id))
    if match:
        cluster, numero, sub = match.groups()
        return f"{cluster}-{numero}.{sub}"
    return gene_id

# Aplica a conversão à coluna 'gene'
df['gene'] = df['gene'].apply(converter_id)

# Salva de volta para XLSX ou CSV
df.to_excel("anotacoes_convertidas.xlsx", index=False)
# ou para CSV tabulado:
# df.to_csv("anotacoes_convertidas.csv", sep='\t', index=False)

print("Conversão concluída com sucesso!")


