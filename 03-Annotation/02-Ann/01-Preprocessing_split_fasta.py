# 1)
# Retirar asteriscos do final das sequências de ORFs
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


process_fasta('longest_orfs.pep', 'longest_orfs_processed.pep')

# 2)
# Dividir o FASTA de longest_orfs em varios chunks mais pequenos para não sobrecarregar a anotação

def split_fasta(input_fasta, output_prefix, chunk_size=10000):
    """
    Divide um arquivo FASTA em vários arquivos, cada um com chunk_size sequências.
    
    Args:
        input_fasta (str): caminho do arquivo FASTA original
        output_prefix (str): prefixo dos arquivos de saída
        chunk_size (int): número de sequências por arquivo
    """
    def write_chunk(seqs, part_num):
        filename = f"{output_prefix}_chunk_{part_num:03d}.fasta"
        with open(filename, 'w') as out_f:
            for header, seq in seqs:
                out_f.write(f">{header}\n")
                out_f.write(f"{seq}\n")
        print(f"Escreveu {len(seqs)} sequências em {filename}")

    seqs = []
    count = 0
    part_num = 1

    with open(input_fasta, 'r') as f:
        header = None
        seq_lines = []
        for line in f:
            line = line.strip()
            if line.startswith(">"):
                if header:
                    seqs.append((header, "".join(seq_lines)))
                    count += 1
                    if count == chunk_size:
                        write_chunk(seqs, part_num)
                        part_num += 1
                        seqs = []
                        count = 0
                header = line[1:]  # remove '>'
                seq_lines = []
            else:
                seq_lines.append(line)
        # adicionar a última sequência
        if header:
            seqs.append((header, "".join(seq_lines)))
        # escrever último chunk, se tiver seqs
        if seqs:
            write_chunk(seqs, part_num)


# Usei as 2 opções abaixo
# Esta usei para o InterProScan porque podia ser mais pesado, então usei chunks mais pequenos
if __name__ == "__main__":
    input_fasta = "longest_orfs_processed.pep"
    output_prefix = "ORFs_InterProScan"
    chunk_size = 2000  
    split_fasta(input_fasta, output_prefix, chunk_size)

# Esta usei para o Blast e para o EggNog porque suportavam chunks maiores
if __name__ == "__main__":
    input_fasta = "longest_orfs_processed.pep"
    output_prefix = "ORFs_chunk"
    chunk_size = 10000  
    split_fasta(input_fasta, output_prefix, chunk_size)
