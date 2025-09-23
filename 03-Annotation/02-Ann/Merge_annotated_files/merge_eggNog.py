# 1) ----------------------------------------------------------------------------------------------------
# Merge dos chunks anotados com eggNog 
import pandas as pd
import glob
import os

# Pasta onde estão os chunks do eggNOG
pasta_chunks = "dados_galaxy/eggnog/"

# Lista todos os arquivos .tabular na pasta
arquivos = glob.glob(os.path.join(pasta_chunks, "*.tabular"))

# Lista para armazenar DataFrames
dfs = []

# Colunas relevantes que queremos manter
colunas_relevantes = [
    '#query', 'seed_ortholog', 'evalue', 'score', 'eggNOG_OGs', 'max_annot_lvl',
    'COG_category', 'Description', 'Preferred_name', 'GOs', 'EC', 'KEGG_ko',
    'KEGG_Pathway', 'KEGG_Module', 'KEGG_Reaction', 'KEGG_rclass', 'BRITE',
    'KEGG_TC', 'CAZy', 'BiGG_Reaction', 'PFAMs'
]

for f in arquivos:
    df = pd.read_csv(f, sep="\t", usecols=lambda c: c in colunas_relevantes)
    dfs.append(df)

# Concatena todos os chunks em um único DataFrame
df_eggnog_master = pd.concat(dfs, ignore_index=True)

# Renomeia colunas principais para padronizar
df_eggnog_master.rename(columns={
    '#query': 'query_id',
    'Description': 'eggNOG_description',
    'GOs': 'GO_eggnog'
}, inplace=True)

# Salva como CSV final
df_eggnog_master.to_csv("eggnog_master.csv", index=False)
print("Master eggNOG CSV gerado com sucesso:", df_eggnog_master.shape)

# 2) ----------------------------------------------------------------------------------------------------
# Remover colunas que não interessam para a anotaçáo final

import pandas as pd

# Caminho do arquivo original
input_file = "eggnog_master.csv"  # ou .tsv, dependendo do separador

# Carregar o arquivo. 
df = pd.read_csv(input_file, sep=",")  

# Escolha apenas as colunas que você quer manter
colunas_desejadas = [
    "query_id",
    "eggNOG_description",
    "Preferred_name",
    "GO_eggnog",
    "KEGG_ko",
    "KEGG_Pathway",
    "EC"
]

# Criar novo DataFrame com apenas essas colunas
df_filtrado = df[colunas_desejadas]

# Salvar em um novo arquivo CSV
df_filtrado.to_csv("eggnog_final.csv", index=False)

print("Arquivo filtrado criado com sucesso!")

