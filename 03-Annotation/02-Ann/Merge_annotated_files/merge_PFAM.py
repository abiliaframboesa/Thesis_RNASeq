import pandas as pd
import os

# Garante que a pasta de resultados existe
os.makedirs("results/pfam", exist_ok=True)

# Lê o CSV do PFAM
df_pfam = pd.read_csv("interproscan_master.csv")

# ===============================
# 1️⃣ PFAM info principal
# ===============================
colunas_pfam = [
    "query_id",
    "Protein_ID",
    "PFAM_ID",
    "PFAM_Description",
#     "Start",
#     "End"
]

df_pfam_info = df_pfam[[col for col in colunas_pfam if col in df_pfam.columns]]
df_pfam_info.to_csv("results/pfam/pfam_info.csv", index=False)
print(" PFAM info CSV gerado:", df_pfam_info.shape)

# ===============================
# 2️⃣ GO termos
# ===============================
def formatar_go(go_str):
    if pd.isna(go_str) or go_str.strip() == "-":
        return ""
    termos = go_str.split(",")
    resultado = []
    for termo in termos:
        termo = termo.strip()
        if not termo:
            continue
        go_id = termo
        descricao = termo
        # Classificação simples por namespace
        if go_id.startswith("GO:000367"): 
            categoria = "molecular_function"
        elif go_id.startswith("GO:000557"): 
            categoria = "cellular_component"
        else:
            categoria = "biological_process"
        resultado.append(f"{go_id}^{categoria}^{descricao}")
    return "`".join(resultado)

df_pfam_go = df_pfam[["query_id", "GO"]].copy()
df_pfam_go["GO_formatado"] = df_pfam_go["GO"].apply(formatar_go)
df_pfam_go.to_csv("results/pfam/pfam_go.csv", index=False)
print(" PFAM GO CSV gerado:", df_pfam_go.shape)

# ===============================
# 3️⃣ Pathways (MetaCyc, Reactome, etc.)
# ===============================
def separar_pathways(pathway_str):
    if pd.isna(pathway_str) or pathway_str.strip() == "-":
        return ""
    return "`".join([p.strip() for p in pathway_str.split("|") if p.strip()])

df_pfam_pathways = df_pfam[["query_id", "Pathways"]].copy()
df_pfam_pathways["Pathways_formatado"] = df_pfam_pathways["Pathways"].apply(separar_pathways)
df_pfam_pathways.to_csv("results/pfam/pfam_pathways.csv", index=False)
print("PFAM Pathways CSV gerado:", df_pfam_pathways.shape)

# ===============================
# 4️⃣ Master separado (opcional)
# ===============================
df_pfam.to_csv("results/pfam/pfam_master_copy.csv", index=False)
print("PFAM master CSV copiado:", df_pfam.shape)
