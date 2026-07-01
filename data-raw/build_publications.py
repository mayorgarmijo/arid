"""
One-shot script to build arid_publications.xlsx and arid_authors.xlsx
from the reference_short / doi columns across all ARID datasets.

Run from project root:
  Rscript -e "..." (see build_refs export step)
  python data-raw/build_publications.py
"""
import re
import pandas as pd
from collections import defaultdict

raw = pd.read_csv("data-raw/all_refs_raw.csv")

# --- Step 1: split combined citations on ";" ---
def split_combined(ref):
    ref = ref.replace("/", ";")
    return [p.strip() for p in ref.split(";") if p.strip()]

# --- Step 2: split secondary citations "X, in Y" / "X ms., in Y" ---
IN_PATTERN = re.compile(r"^(.*?)\s*,?\s+in\s+(.+)$", re.IGNORECASE)

def split_secondary(piece):
    m = IN_PATTERN.match(piece)
    if m:
        return [m.group(1).strip(), m.group(2).strip()]
    return [piece]

# --- Step 3: parse a single citation piece into author_string / year / flags ---
YEAR_PATTERN = re.compile(r"(\d{4}[a-z]?)")

def parse_piece(piece):
    is_cp = bool(re.search(r"\bC\.?P\.?\b", piece))
    is_ms = bool(re.search(r"\bms\.?\b", piece, re.IGNORECASE))
    years = YEAR_PATTERN.findall(piece)
    year = years[0] if years else None
    # author string = text before first year, strip trailing punctuation/parens
    if year:
        author_str = piece.split(year)[0]
    else:
        author_str = piece
    author_str = re.sub(r"[\(\),.]+$", "", author_str).strip()
    author_str = re.sub(r"\s+(ms\.?|C\.?P\.?)$", "", author_str, flags=re.IGNORECASE).strip()
    has_et_al = bool(re.search(r"et al\.?", author_str, re.IGNORECASE))
    author_str = re.sub(r"\s*et al\.?\s*", "", author_str, flags=re.IGNORECASE).strip()
    author_str = re.sub(r"[\s,]+$", "", author_str).strip()
    return author_str, year, has_et_al, is_cp, is_ms

def parse_authors(author_str):
    # split on " and " / " & " / ","
    parts = re.split(r"\s+and\s+|\s*&\s*|\s*,\s*", author_str)
    return [p.strip() for p in parts if p.strip()]

# --- Build publications table ---
pub_records = {}  # key: (author_str, year) -> record
for _, row in raw.iterrows():
    ref, doi, source = row["reference_short"], row["doi"], row["source"]
    combined_pieces = split_combined(ref)
    for cp in combined_pieces:
        sub_pieces = split_secondary(cp)
        for piece in sub_pieces:
            author_str, year, has_et_al, is_cp, is_ms = parse_piece(piece)
            if not author_str:
                continue
            key = (author_str, year)
            if key not in pub_records:
                pub_records[key] = {
                    "author_string": author_str,
                    "year": year,
                    "has_et_al": has_et_al,
                    "is_personal_comm": is_cp,
                    "is_unpublished_ms": is_ms,
                    "doi": None,
                    "sources": set(),
                }
            rec = pub_records[key]
            rec["sources"].add(source)
            rec["has_et_al"] = rec["has_et_al"] or has_et_al
            rec["is_personal_comm"] = rec["is_personal_comm"] or is_cp
            rec["is_unpublished_ms"] = rec["is_unpublished_ms"] or is_ms
            # attach doi only when the whole original ref (no split needed) matches
            if pd.notna(doi) and ref.strip() == piece.strip():
                rec["doi"] = doi

pubs = pd.DataFrame(pub_records.values())
pubs["sources"] = pubs["sources"].apply(lambda s: ", ".join(sorted(s)))
pubs["year_numeric"] = pubs["year"].str.extract(r"(\d{4})").astype("Int64")
pubs = pubs.sort_values(["year_numeric", "author_string"]).reset_index(drop=True)
pubs = pubs[["author_string", "year", "year_numeric", "has_et_al", "is_personal_comm", "is_unpublished_ms", "doi", "sources"]]
pubs.to_excel("data-raw/arid_publications.xlsx", index=False)
print(f"arid_publications.xlsx: {len(pubs)} unique publications")

# --- Build authors table ---
author_counts = defaultdict(lambda: {"n_publications": 0, "years": set()})
for rec in pub_records.values():
    authors = parse_authors(rec["author_string"])
    for auth in authors:
        author_counts[auth]["n_publications"] += 1
        if rec["year"]:
            author_counts[auth]["years"].add(rec["year"])

authors_df = pd.DataFrame([
    {"author": a, "n_publications": d["n_publications"],
     "years": ", ".join(sorted(d["years"]))}
    for a, d in author_counts.items()
])
authors_df = authors_df.sort_values("author").reset_index(drop=True)
authors_df.to_excel("data-raw/arid_authors.xlsx", index=False)
print(f"arid_authors.xlsx: {len(authors_df)} unique author names")
