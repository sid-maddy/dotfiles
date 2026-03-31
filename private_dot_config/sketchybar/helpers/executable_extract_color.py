#!/usr/bin/env python3
"""Extract dominant color from a BMP file. Zero dependencies (stdlib only)."""

import os
import struct
import sys
from collections import Counter

FALLBACK = "0xff59c2ff"


def extract(bmp_path):
    with open(bmp_path, "rb") as f:
        data = f.read()

    offset = struct.unpack_from("<I", data, 10)[0]
    width = struct.unpack_from("<i", data, 18)[0]
    height = abs(struct.unpack_from("<i", data, 22)[0])
    bpp = struct.unpack_from("<H", data, 28)[0]

    if bpp not in (24, 32):
        return FALLBACK

    stride = bpp // 8
    row_size = ((width * stride + 3) // 4) * 4

    pixels = []
    for y in range(height):
        for x in range(width):
            idx = offset + y * row_size + x * stride
            if idx + 2 >= len(data):
                continue
            b, g, r = data[idx], data[idx + 1], data[idx + 2]
            pixels.append((r, g, b))

    # Filter out near-white (transparent composited onto white) and near-black (shadows)
    filtered = [
        (r, g, b)
        for r, g, b in pixels
        if 50 < r + g + b < 660
        and not (r > 220 and g > 220 and b > 220)
        and not (r < 25 and g < 25 and b < 25)
    ]
    if not filtered:
        filtered = pixels

    # Histogram binning — group into 32-wide buckets
    BIN = 32
    bins = Counter()
    for r, g, b in filtered:
        bins[(r // BIN, g // BIN, b // BIN)] += 1

    top_bin = bins.most_common(1)[0][0]

    # Average the pixels within the dominant bin for a smoother result
    in_bin = [
        (r, g, b)
        for r, g, b in filtered
        if r // BIN == top_bin[0] and g // BIN == top_bin[1] and b // BIN == top_bin[2]
    ]
    r = sum(p[0] for p in in_bin) // len(in_bin)
    g = sum(p[1] for p in in_bin) // len(in_bin)
    b = sum(p[2] for p in in_bin) // len(in_bin)

    # Boost saturation for vibrancy (icons tend to wash out after averaging)
    mx = max(r, g, b)
    mn = min(r, g, b)
    if mx > 0 and mx != mn:
        factor = 1.4
        r = min(255, int(mn + (r - mn) * factor))
        g = min(255, int(mn + (g - mn) * factor))
        b = min(255, int(mn + (b - mn) * factor))

    return f"0xff{r:02x}{g:02x}{b:02x}"


if __name__ == "__main__":
    bmp_path = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("BMP_PATH", "")
    if not bmp_path or not os.path.isfile(bmp_path):
        print(FALLBACK)
        sys.exit(0)
    try:
        print(extract(bmp_path))
    except Exception:
        print(FALLBACK)
