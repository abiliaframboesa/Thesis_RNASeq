# Objetivo será filtrar apenas  o nome do cluster(query_id) e o código da proteína do NCBI nr feita através da anotação completa do BLastP para NCBI nr 
# O ficheiro de input vem da pasta da anotação onde se faz a anotação para o NCBI nr

input_file = "results/final_anotation/blastp_ncbi_nr_final.csv"
output_file = "results/final_anotation/filter_cluster_and_protein_id.csv"

import re

clusters_seen = set()  # para rastrear clusters já processados

with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    header = f_in.readline()
    f_out.write(header)  # mantém o header original

    for line in f_in:
        line = line.strip()
        if not line:
            continue
        
        cluster_field, rest = line.split(",", 1)

        # Mantém o nome original do cluster
        cluster_new = cluster_field

        # Ignorar clusters duplicados
        if cluster_new in clusters_seen:
            continue
        clusters_seen.add(cluster_new)

        # Pegar apenas o XP_... (remover número e ^ antes)
        rest_parts = rest.split("^")
        xp_part = rest_parts[1]

        # # Pegar o texto dentro dos colchetes
        # bracket_match = re.search(r"\[.*?\]", rest)
        # bracket_part = bracket_match.group(0) if bracket_match else ""

        # Montar linha final
        new_line = f"{cluster_new},{xp_part}\n"
        f_out.write(new_line)

print(f"Arquivo processado com sucesso: {output_file}")
