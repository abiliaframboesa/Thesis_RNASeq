# retirar asteriscos do final das sequências
# e ajustar os cabeçalhos para o formato >Cluster_x_y.pN

import re

def process_fasta(input_file, output_file):
    pattern = re.compile(r'(>Cluster_\d+_\d+\.p\d+)')
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            line = line.rstrip('\n')
            if line.startswith('>'):
                # Busca o padrão >Cluster_x_y.pN
                match = pattern.match(line)
                if match:
                    # Escreve só a parte do padrão, sem o resto
                    f_out.write(match.group(1) + '\n')
                else:
                    # Se não bate com o padrão, escreve a linha normal
                    f_out.write(line + '\n')
            else:
                # Remove '*' no final da sequência, se houver
                if line.endswith('*'):
                    line = line[:-1]
                f_out.write(line + '\n')


# Exemplo de uso:
process_fasta('longest_orfs.pep', 'longest_orfs_processed.pep')
