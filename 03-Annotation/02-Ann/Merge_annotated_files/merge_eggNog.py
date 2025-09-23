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
