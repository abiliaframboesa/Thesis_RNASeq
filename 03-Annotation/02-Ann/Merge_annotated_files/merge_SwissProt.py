# como correr o código no terminal: 
# python parse_blast_pairwise.py --in dados_galaxy/blastp_swissprot --out blastp_swissprot.csv
# alterar os nomes dos ficheiros conforme necessário

# Dar merge dos dados de anotação do SwissProt

import re
import os
import argparse
import pandas as pd

# Expressões regulares para capturar informação
re_query = re.compile(r"^Query=\s+(\S+)")
re_qlen = re.compile(r"^Length=(\d+)")
re_subject = re.compile(r"^>(\S+)(.*)")
re_slen = re.compile(r"^Length=(\d+)")
re_score = re.compile(r"Score =\s+([\d\.]+) bits.*Expect =\s+([\deE\.-]+)")
re_identities = re.compile(r"Identities = (\d+)/(\d+) \((\d+)%\), Positives = (\d+)/(\d+) \((\d+)%\), Gaps = (\d+)/(\d+) \((\d+)%\)")

def parse_blast_file(path):
    results = []
    with open(path, encoding="utf-8", errors="ignore") as fh:
        query_id, qlen, subject_id, subject_desc, slen = None, None, None, None, None
        bitscore, evalue, align_len, identities, pident, positives, gaps = None, None, None, None, None, None, None

        for line in fh:
            line = line.strip()
            if not line:
                continue

            m = re_query.match(line)
            if m:
                query_id = m.group(1)
                qlen = None  # será lido logo a seguir
                continue

            m = re_qlen.match(line)
            if m and subject_id is None and query_id is not None and qlen is None:
                qlen = int(m.group(1))
                continue

            m = re_subject.match(line)
            if m:
                subject_id = m.group(1)
                subject_desc = m.group(2).strip()
                slen = None
                continue

            m = re_slen.match(line)
            if m and subject_id is not None and slen is None:
                slen = int(m.group(1))
                continue

            m = re_score.match(line)
            if m and subject_id is not None:
                bitscore = float(m.group(1))
                evalue = m.group(2)
                continue

            m = re_identities.search(line)
            if m and subject_id is not None:
                identities = int(m.group(1))
                align_len = int(m.group(2))
                pident = float(m.group(3))
                positives = float(m.group(6))
                gaps = float(m.group(9))

                qcov = round((align_len / qlen) * 100, 2) if qlen else None
                scov = round((align_len / slen) * 100, 2) if slen else None

                results.append({
                    "query_id": query_id,
                    "qlen": qlen,
                    "subject_id": subject_id,
                    "subject_desc": subject_desc,
                    "slen": slen,
                    "bitscore": bitscore,
                    "evalue": evalue,
                    "align_len": align_len,
                    "identities": identities,
                    "pident": pident,
                    "positives": positives,
                    "gaps": gaps,
                    "qcov": qcov,
                    "scov": scov,
                    "source_file": os.path.basename(path)
                })

                subject_id, subject_desc, slen = None, None, None
                bitscore, evalue, align_len, identities, pident, positives, gaps = None, None, None, None, None, None, None
    return results

def parse_folder(infolder, outfile):
    all_hits = []
    for root, _, files in os.walk(infolder):
        for f in files:
            if f.endswith((".txt", ".out", ".blast")):
                path = os.path.join(root, f)
                print(f"Parsing {path} ...")
                hits = parse_blast_file(path)
                all_hits.extend(hits)
    
    df = pd.DataFrame(all_hits)
    df.to_csv(outfile, index=False)
    print(f"\n Guardado: {outfile} ({len(df)} hits)\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parse BLAST pairwise output into CSV")
    parser.add_argument("--in", dest="infolder", required=True, help="Pasta com ficheiros BLAST .txt/.out")
    parser.add_argument("--out", dest="outfile", required=True, help="Ficheiro CSV de saída")
    args = parser.parse_args()
    parse_folder(args.infolder, args.outfile)
