import pandas as pd
import requests
import time

# ---------------------------
# Funções auxiliares
# ---------------------------

GENERIC_GO = {"GO:0008150", "GO:0003674", "GO:0005575"}  # termos muito gerais

def get_go_description(go_id):
    """Busca descrição de GO term via QuickGO"""
    try:
        url = f"https://www.ebi.ac.uk/QuickGO/services/ontology/go/terms/{go_id}"
        r = requests.get(url, headers={"Accept": "application/json"})
        if r.status_code == 200:
            data = r.json()
            return data['results'][0]['name']
    except:
        pass
    return go_id  # fallback

def get_kegg_description(pathway_id):
    """Busca descrição de pathway KEGG via REST API"""
    try:
        url = f"http://rest.kegg.jp/get/{pathway_id}"
        r = requests.get(url)
        if r.status_code == 200:
            for line in r.text.splitlines():
                if line.startswith("NAME"):
                    return line.replace("NAME", "").strip()
    except:
        pass
    return pathway_id  # fallback

def process_go_column(go_string, max_terms=5):
    """Transforma string com GO terms em lista reduzida de descrições"""
    if pd.isna(go_string) or go_string.strip() == "":
        return ""

    go_terms = []
    for term in go_string.split(','):
        go_id = term.strip()
        if go_id not in GENERIC_GO:
            go_terms.append(go_id)

    go_terms = list(set(go_terms))  # únicos

    descriptions = []
    for go_id in go_terms[:max_terms]:  # limita número de termos
        desc = get_go_description(go_id)
        descriptions.append(f"{desc} ({go_id})")
        time.sleep(0.1)  # evitar sobrecarga da API

    return "; ".join(descriptions)

def process_kegg_column(cell):
    """Transforma lista de pathways KEGG em descrições"""
    if pd.isna(cell):
        return ""
    pathways = [p.strip() for p in cell.split(',') if p.strip() != ""]
    descriptions = []
    for p in pathways:
        desc = get_kegg_description(p)
        descriptions.append(f"{desc} ({p})")
        time.sleep(0.1)
    return "; ".join(descriptions)

# ---------------------------
# Leitura do arquivo de saída anterior
# ---------------------------

input_file = "eggnog_final.csv"  # output da análise anterior
df = pd.read_csv(input_file)

# ---------------------------
# Montar resumo por cluster
# ---------------------------

output = []

for cluster in df['query_id'].unique():
    row = df[df['query_id'] == cluster].iloc[0]

    # Processar GO
    go_bp = process_go_column(row.get('GO_eggnog', ""), max_terms=5)
    go_mf = process_go_column(row.get('GO_eggnog', ""), max_terms=5)
    go_cc = process_go_column(row.get('GO_eggnog', ""), max_terms=5)

    # EggNOG
    egg_desc = row.get('eggNOG_description', "")
    egg_cat = row.get('COG_category', "")

    # KEGG
    kegg_path = process_kegg_column(row.get('KEGG_Pathway', ""))
    ec_number = row.get('EC', "")

    output.append({
        "Cluster": cluster,
        "EggNOG": egg_desc,
        "Categoria": egg_cat,
        "GO_BP": go_bp,
        "GO_MF": go_mf,
        "GO_CC": go_cc,
        "KEGG_pathway": kegg_path,
        "EC_number": ec_number
    })

# ---------------------------
# Exportar resumo final
# ---------------------------

output_df = pd.DataFrame(output)
output_df.to_csv("eggnog_final_anotado.csv", index=False)
output_df.to_excel("eggnog_final_anotado.xlsx", index=False)

print(" Arquivo final criado: eggnog_final_anotado.csv / eggnog_final_anotado.xlsx")
