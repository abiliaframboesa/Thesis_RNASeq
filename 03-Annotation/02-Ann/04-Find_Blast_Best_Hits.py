# 1) -----------------------------------------------------------------------------------------------------------------

# As anotações pelo BlastP foram feitas para encontrar os top 25 hits de possíveis proteínas para cada transcrito. 
# Teve de ser feita uma filtragem para escolher apenas 1 tendo em conta os critérios apresentados abaixo: menor evalue, maior bitscore, maior qcov, maior scov

import pandas as pd

# Lê o ficheiro CSV
df = pd.read_csv("blastp_nr2.csv")  # de uma vez usar este, da outra usar o da swissprot
df = pd.read_csv("blastp_swissprot.csv")

# Verifica as colunas
required_cols = ['query_id', 'subject_id', 'evalue', 'bitscore', 'qcov', 'scov']
for col in required_cols:
    if col not in df.columns:
        raise ValueError(f"Coluna {col} não encontrada no ficheiro!")

# Função para selecionar o melhor hit
def select_best_hit(group):
    # Ordena: menor evalue, maior bitscore, maior qcov, maior scov
    return group.sort_values(
        by=['evalue', 'bitscore', 'qcov', 'scov'],
        ascending=[True, False, False, False]
    ).iloc[0]

# Aplica a função para cada cluster
best_hits = df.groupby('query_id').apply(select_best_hit).reset_index(drop=True)

# Marca a coluna best_hit
best_hits['best_hit'] = True

# Guarda o resultado PARA NCBI
best_hits.to_csv("best_hits_por_cluster_ncbi.csv", index=False)
print("Arquivo 'best_hits_por_cluster_ncbi.csv' criado com os melhores hits por cluster.")


# Guarda o resultado PARA SWISSPROT
best_hits.to_csv("best_hits_por_cluster_swissprot.csv", index=False)
print("Arquivo 'best_hits_por_cluster.csv' criado com os melhores hits por cluster.")

# 2) ----------------------------------------------------------------------------------------------- 
# Tornar o ficheiro mais compacto de forma a ter apenas 2 colunas: query_id e Ncbi-Nr_Blast-p

# Ler o ficheiro blastp (ajusta o nome do input)
df_blast = pd.read_csv("best_hits_por_cluster_ncbi_nr.csv")

# Reset do índice
df_blast = df_blast.reset_index(drop=True)

# Criar coluna com a numeração da hit (A.Number = rank por query_id)
df_blast["A.Number"] = df_blast.groupby("query_id").cumcount() + 1

# Formatar string consolidada
def formatar_blast(row):
    return (
        f"{row['A.Number']}^"
        f"{row['subject_id']}^"
        f"{row['qlen']}^"
        f"{row['slen']}^"
        f"{row['pident']}^"
        f"{row['gaps']}^"
        f"{row['qcov']}^"
        f"{row['evalue']}^"
        f"{row['bitscore']}^"
        f"{row['subject_desc']}"
    )

df_blast["Ncbi-Nr_Blast-p"] = df_blast.apply(formatar_blast, axis=1)

# Manter apenas query_id + coluna consolidada
df_final = df_blast[["query_id", "Ncbi-Nr_Blast-p"]]

# Agrupar por query_id (caso haja múltiplos hits por query)
df_final = df_final.groupby("query_id")["Ncbi-Nr_Blast-p"].apply(lambda x: "`".join(x)).reset_index()

# Salvar resultado
df_final.to_csv("results/blastp_ncbi_nr/blastp_ncbi_nr_final.csv", index=False)

print(" Blastp NCBI-NR CSV final gerado:", df_final.shape)




