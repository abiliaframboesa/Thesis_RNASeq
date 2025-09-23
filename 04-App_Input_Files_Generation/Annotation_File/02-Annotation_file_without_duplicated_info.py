# Remover os identificadores map do kegg_pathway visto que eram iguais aos identificadores de ko. 
# E optámos por manter os identificadores de ko. 
# Remoção de go_bp, go_mf, go_cc para ficar apenas com coluna go para evitar informação duplicada, já que as colunas eram iguais.

import pandas as pd
import re
import os

# Nome do ficheiro de entrada
entrada = "anotacoes_convertidas.xlsx"

# Gerar automaticamente o nome do ficheiro de saída
nome, ext = os.path.splitext(entrada)
saida = f"{nome}_sem_maps_e_go{ext}"

map_removidos = 0
duplicatas_removidas = 0

def limpar_kegg(valor):
    global map_removidos, duplicatas_removidas
    if pd.isna(valor):
        return valor
    partes = [p.strip() for p in valor.split(';')]

    # Contar e remover os maps
    maps = [p for p in partes if re.search(r'\(map\d+\)', p)]
    map_removidos += len(maps)
    filtradas = [p for p in partes if p not in maps]

    # Remover duplicatas mantendo ordem
    unicas = list(dict.fromkeys(filtradas))
    duplicatas_removidas += len(filtradas) - len(unicas)

    return '; '.join(unicas) if unicas else None

# Carregar o Excel
df = pd.read_excel(entrada)

# Limpar KEGG_pathway
if "KEGG_pathway" in df.columns:
    df["KEGG_pathway"] = df["KEGG_pathway"].apply(limpar_kegg)

# Remover colunas GO_MF e GO_CC se existirem
colunas_para_remover = [c for c in ["GO_MF", "GO_CC"] if c in df.columns]
df.drop(columns=colunas_para_remover, inplace=True)

# Renomear GO_BP para GO se existir
if "GO_BP" in df.columns:
    df.rename(columns={"GO_BP": "GO"}, inplace=True)

# Salvar resultado
df.to_excel(saida, index=False)

# Mostrar resumo no terminal
print(f"✅ Processo concluído!")
print(f"➡ Total de linhas processadas: {len(df)}")
print(f"➡ Total de 'map' removidos: {map_removidos}")
print(f"➡ Total de duplicatas removidas: {duplicatas_removidas}")
if colunas_para_remover:
    print(f"➡ Colunas removidas: {', '.join(colunas_para_remover)}")
else:
    print("➡ Nenhuma coluna GO_MF ou GO_CC encontrada.")
if "GO" in df.columns:
    print("➡ Coluna GO_BP foi renomeada para GO.")
print(f"📂 Resultado salvo em '{saida}'")
