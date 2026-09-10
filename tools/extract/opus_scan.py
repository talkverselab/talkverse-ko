"""
Scan 공개 말뭉치 2024 Korean corpus for candidate scenario lines.

Reads `corpus_v2024.txt.gz` line by line, looks for utterances that
plausibly belong to one of our scenario domains (cafe, taxi, convenience
store, guesthouse, k-drama first meeting), and writes the matches to JSON
for manual curation.

This is a *prospecting* step, not a final extraction. The chosen lines
will be hand-relabeled with speakers, glosses, and annotations before being
seeded into the app.

Usage:
    python tools/extract/opus_scan.py [--limit N] [--per-domain K]

Defaults to scanning the first 800,000 lines and keeping up to 150 hits
per domain. The corpus is ~552 MB compressed; scanning the entire file
takes a few minutes.
"""

from __future__ import annotations

import argparse
import gzip
import json
import os
import re
import sys
from collections import defaultdict

INPUT = r"D:\OneDrive\DATA_Raw\languages\ko\chat\corpus_v2024.txt.gz"
OUTPUT = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "opus_samples.json"
)

# Domain keyword groups. A line is tagged with the first domain whose
# keyword appears. Keywords are intentionally broad — we'll filter quality
# in a second pass.
DOMAINS: dict[str, list[str]] = {
    "cafe": [
        "아메리카노", "라떼", "카페", "커피", "바리스타",
        "톨로", "벤티", "그란데", "사이즈는", "주문",
        "진동벨", "테이크아웃", "매장에서", "결제는",
    ],
    "taxi": [
        "택시", "기사님", "주소", "여기서 세워", "신호",
        "얼마나 걸려", "분 정도", "다 왔어요", "이쪽으로",
        "직진해", "유턴", "정류장",
    ],
    "cvs": [
        "편의점", "봉투", "계산", "포인트", "적립",
        "원입니다", "원이에요", "스캔", "현금",
    ],
    "guesthouse": [
        "게스트하우스", "호텔", "체크인", "체크아웃",
        "예약", "도미토리", "조식", "키 카드", "프론트",
    ],
    "kdrama_meet": [
        "처음 뵙겠습니다", "잘 부탁", "이름이 어떻게",
        "어디서 오셨", "한국말 잘",
    ],
}

# Lines outside this length range are noise (single words, monologues).
MIN_LEN = 4
MAX_LEN = 80

# Quick filter: must contain Hangul.
HANGUL_RE = re.compile(r"[가-힯]")


def scan(limit: int, per_domain: int) -> dict[str, list[str]]:
    if not os.path.exists(INPUT):
        sys.exit(f"corpus not found: {INPUT}")

    results: dict[str, list[str]] = defaultdict(list)
    domain_full: set[str] = set()
    total_kept = 0

    with gzip.open(INPUT, "rt", encoding="utf-8", errors="ignore") as f:
        for i, raw in enumerate(f):
            if i >= limit:
                break
            line = raw.strip()
            if not line or len(line) < MIN_LEN or len(line) > MAX_LEN:
                continue
            if not HANGUL_RE.search(line):
                continue

            for domain, keywords in DOMAINS.items():
                if domain in domain_full:
                    continue
                if any(kw in line for kw in keywords):
                    if line not in results[domain]:
                        results[domain].append(line)
                        total_kept += 1
                        if len(results[domain]) >= per_domain:
                            domain_full.add(domain)
                    break

            if i and i % 100000 == 0:
                snap = ", ".join(f"{k}:{len(v)}" for k, v in results.items())
                print(f"  scanned {i:,} lines | {snap}", flush=True)

            if len(domain_full) == len(DOMAINS):
                print(f"  all domains full after {i:,} lines", flush=True)
                break

    print(f"\nDone. total kept = {total_kept}")
    return dict(results)


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--limit", type=int, default=800_000,
                   help="max lines to scan (default 800K)")
    p.add_argument("--per-domain", type=int, default=150,
                   help="max hits to keep per domain (default 150)")
    args = p.parse_args()

    print(f"scanning {INPUT}")
    print(f"  limit={args.limit:,}  per-domain={args.per_domain}")
    print()

    samples = scan(args.limit, args.per_domain)

    with open(OUTPUT, "w", encoding="utf-8") as f:
        json.dump(samples, f, ensure_ascii=False, indent=2)

    print()
    print(f"wrote {OUTPUT}")
    for k, v in samples.items():
        print(f"  {k:14s}  {len(v):4d} samples")


if __name__ == "__main__":
    main()
