# input_file = "Trinity_NCont_Clusters.fasta"
# output_file = "cluster_trinity.csv"

# with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
#     f_out.write("Cluster,Trinity\n")  # header do CSV

#     for line in f_in:
#         line = line.strip()
#         if line.startswith(">"):
#             # Remove ">"
#             header = line[1:]
#             # Separar Cluster e Trinity
#             if "_" in header:
#                 cluster, trinity = header.split("_", 1)
#                 f_out.write(f"{cluster},{trinity}\n")

# print(f"Arquivo CSV criado: {output_file}")


# input_clusters = "Trinity_NCont_Clusters_C_Headers.txt"          # lista simples com Cluster_XXXXX_Y
# transcripts_fasta = "Trinity_NCont_Clusters.fasta"  # fasta com headers tipo Cluster-XXXXX.Y_TRINITY...
# output_file = "clusters_associados.csv"

# # Carregar clusters normalizados
# clusters_set = set()
# with open(input_clusters) as f:
#     for line in f:
#         if line.strip().startswith(">"):
#             clusters_set.add(line.strip()[1:])  # tira o ">"

# # Abrir fasta de transcritos e mapear
# associacoes = []
# with open(transcripts_fasta) as f:
#     for line in f:
#         if line.startswith(">"):
#             header = line[1:].strip()
#             cluster_part, trinity = header.split("_", 1)
#             cluster_norm = cluster_part.replace("-", "_")  # ex: Cluster-23194.0 -> Cluster_23194_0

#             if cluster_norm in clusters_set:
#                 associacoes.append((cluster_norm, cluster_part, trinity))

# # Escrever CSV final
# with open(output_file, "w") as out:
#     out.write("Cluster_norm,Cluster_transcript,Trinity\n")
#     for cluster_norm, cluster_part, trinity in associacoes:
#         out.write(f"{cluster_norm},{cluster_part},{trinity}\n")

# print(f"Associações guardadas em {output_file}")


# import csv

# csv_file = "preprocessing_fasta/cluster_trinity.csv"
# txt_file = "preprocessing_fasta/Trinity_NCont_Clusters_C_Headers.txt"
# output_file = "preprocessing_fasta/clusters_associados.csv"

# # 1. Ler CSV em dict {Cluster_norm: Trinity}
# csv_dict = {}
# with open(csv_file) as f:
#     reader = csv.DictReader(f)
#     for row in reader:
#         cluster_dash = row["Cluster"]  # Cluster-23194.0
#         cluster_norm = cluster_dash.replace("-", "_")  # -> Cluster_23194_0
#         csv_dict[cluster_norm] = (cluster_dash, row["Trinity"])

# # 2. Ler TXT e associar
# results = []
# with open(txt_file) as f:
#     for line in f:
#         if line.startswith(">"):
#             cluster_norm = line[1:].strip()  # tira ">"
#             if cluster_norm in csv_dict:
#                 cluster_dash, trinity = csv_dict[cluster_norm]
#                 results.append((cluster_norm, cluster_dash, trinity))
#             else:
#                 results.append((cluster_norm, "NA", "NA"))

# # 3. Escrever saída
# with open(output_file, "w") as out:
#     out.write("Cluster_norm,Cluster_csv,Trinity\n")
#     for row in results:
#         out.write(",".join(row) + "\n")

# print(f"Associações guardadas em {output_file}")


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

