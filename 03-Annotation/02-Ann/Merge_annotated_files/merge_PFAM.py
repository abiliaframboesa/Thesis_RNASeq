
import pandas as pd
import glob
import os

# Pasta onde estão os chunks do InterProScan
pasta_chunks = "dados_galaxy/interproscan/"

# Lista todos os arquivos .tabular na pasta
arquivos = glob.glob(os.path.join(pasta_chunks, "*.tabular"))

# Lista para armazenar DataFrames
dfs = []

# Colunas que queremos manter na tabela final
colunas_relevantes = [
    "Cluster_file", "Protein_ID", "PFAM_ID", "PFAM_Description",
    "Start", "End", "GO", "Pathways"
]

# Loop para ler cada chunk
for f in arquivos:
    df = pd.read_csv(
        f,
        sep="\t",
        usecols=lambda c: c in colunas_relevantes,
        header=None,
        names=[
            "Cluster_file", "Protein_ID", "Length", "DB", "DB_ID", "DB_Description",
            "Start", "End", "Evalue", "T/F", "Date", "PFAM_ID", "PFAM_Description",
            "GO", "Pathways"
        ]
    )
    # Mantemos só as colunas relevantes
    df = df[colunas_relevantes]
    dfs.append(df)


# Concatena todos os chunks em um único DataFrame
df_master = pd.concat(dfs, ignore_index=True)

# Renomeia colunas principais para padronizar
df_master.rename(columns={
    'Cluster_file': 'query_id'
}, inplace=True)


# Salva como CSV final
df_master.to_csv("interproscan_master.csv", index=False)
print("Master InterProScan CSV gerado com sucesso:", df_master.shape)

