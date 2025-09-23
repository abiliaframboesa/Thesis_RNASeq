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
