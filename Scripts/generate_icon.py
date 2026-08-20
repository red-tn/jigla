#!/usr/bin/env python3
"""Generates the placeholder Jiggler.app icon as a macOS .iconset directory.

Requires Pillow (`pip install pillow`). Run from the repo root:

    python Scripts/generate_icon.py

Regenerates every PNG in Resources/AppIcon.iconset/. Scripts/build-app.sh
then compiles that directory into AppIcon.icns via `iconutil` on macOS.
"""
import math
import os

from PIL import Image, ImageDraw

ICONSET_DIR = os.path.join(os.path.dirname(__file__), "..", "Resources", "AppIcon.iconset")
MASTER_SIZE = 1024

ICONSET_SIZES = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024),
]

BACKGROUND_TOP = (90, 130, 246)      # blue
BACKGROUND_BOTTOM = (124, 58, 237)   # purple
GLYPH_COLOR = (255, 255, 255, 255)
MOTION_COLOR = (255, 255, 255, 160)


def draw_background(size):
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    gradient = Image.new("RGBA", (1, size), (0, 0, 0, 255))
    for y in range(size):
        t = y / (size - 1)
        r = round(BACKGROUND_TOP[0] + (BACKGROUND_BOTTOM[0] - BACKGROUND_TOP[0]) * t)
        g = round(BACKGROUND_TOP[1] + (BACKGROUND_BOTTOM[1] - BACKGROUND_TOP[1]) * t)
        b = round(BACKGROUND_TOP[2] + (BACKGROUND_BOTTOM[2] - BACKGROUND_TOP[2]) * t)
        gradient.putpixel((0, y), (r, g, b, 255))
    gradient = gradient.resize((size, size))

    mask = Image.new("L", (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    corner_radius = round(size * 0.2237)  # macOS "squircle-ish" rounded-rect radius
    mask_draw.rounded_rectangle([(0, 0), (size - 1, size - 1)], radius=corner_radius, fill=255)

    image.paste(gradient, (0, 0), mask)
    return image


def cursor_arrow_points(scale, offset_x, offset_y):
    # Classic pointer-arrow silhouette, defined in a 100x100 box, then scaled.
    raw = [
        (0, 0),
        (0, 68),
        (19, 53),
        (31, 79),
        (42, 74),
        (30, 49),
        (54, 49),
    ]
    return [(offset_x + x * scale, offset_y + y * scale) for x, y in raw]


def draw_glyph(image, size):
    draw = ImageDraw.Draw(image, "RGBA")
    scale = size * 0.0068
    offset_x = size * 0.30
    offset_y = size * 0.28
    points = cursor_arrow_points(scale, offset_x, offset_y)
    draw.polygon(points, fill=GLYPH_COLOR)

    center_x = size * 0.60
    center_y = size * 0.60
    for i, radius_ratio in enumerate((0.14, 0.20, 0.26)):
        radius = size * radius_ratio
        bbox = [
            (center_x - radius, center_y - radius),
            (center_x + radius, center_y + radius),
        ]
        width = max(2, round(size * 0.012))
        alpha = MOTION_COLOR[3] - i * 40
        draw.arc(bbox, start=300, end=345, fill=(255, 255, 255, max(alpha, 40)), width=width)


def main():
    os.makedirs(ICONSET_DIR, exist_ok=True)
    master = draw_background(MASTER_SIZE)
    draw_glyph(master, MASTER_SIZE)

    for filename, size in ICONSET_SIZES:
        resized = master.resize((size, size), Image.LANCZOS)
        resized.save(os.path.join(ICONSET_DIR, filename))
        print(f"wrote {filename} ({size}x{size})")


if __name__ == "__main__":
    main()
