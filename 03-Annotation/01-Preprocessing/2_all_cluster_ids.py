
import pandas as pd

# Arquivos de entrada
csv_file = "preprocessing_fasta/cluster_trinity.csv"
txt_file = "preprocessing_fasta/Trinity_NCont_Clusters_C_Headers.txt"
output_file = "preprocessing_fasta/clusters_associados.csv"

# Ler CSV
df_csv = pd.read_csv(csv_file)

# Normalizar nomes do CSV para o formato do TXT
def normalize_cluster(cluster_name):
    # Transformar Cluster-23194.0 -> Cluster_23194_0
    cluster_norm = cluster_name.replace("-", "_").replace(".", "_")
    return cluster_norm

df_csv["Cluster_norm"] = df_csv["Cluster"].apply(normalize_cluster)

# Ler TXT e extrair os clusters
with open(txt_file, "r") as f:
    txt_clusters = [line.strip().lstrip(">") for line in f if line.startswith(">")]

# Criar DataFrame com clusters do TXT
df_txt = pd.DataFrame({"Cluster_norm": txt_clusters})

# Fazer merge para associar CSV ao TXT
df_merged = df_txt.merge(df_csv[["Cluster_norm", "Cluster", "Trinity"]], 
                         on="Cluster_norm", how="left")

# Substituir NaN por 'NA'
df_merged.fillna("NA", inplace=True)

# Salvar resultado
df_merged.to_csv(output_file, index=False)

print(f"Associação concluída! Resultado salvo em: {output_file}")

