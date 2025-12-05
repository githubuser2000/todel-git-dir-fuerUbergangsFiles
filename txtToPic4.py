#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
txtToPicHD_multi.py - HD-Textbilder mit Rändern, Outline, automatischer Skalierung
und automatischer Aufteilung in mehrere Bilder, wenn Text zu groß ist.
"""

import sys
from PIL import Image, ImageDraw, ImageFont
import textwrap
import subprocess
import math
import os

def find_system_font():
    """Systemweite Sans- oder Arial-ähnliche Font über fc-list finden"""
    try:
        output = subprocess.check_output(['fc-list', ':family'], text=True)
        lines = output.split('\n')
        for line in lines:
            if any(name in line for name in ['DejaVu Sans', 'Liberation Sans', 'FreeSans']):
                font_name = line.split(':')[0].strip()
                return font_name
    except Exception:
        pass
    return None

def split_text_to_chunks(lines, draw, font, max_width, max_height, line_spacing):
    """Teilt Text in Chunks, die in ein Bild passen"""
    chunks = []
    current_chunk = []
    current_height = 0

    for line in lines:
        bbox = draw.textbbox((0,0), line, font=font)
        lh = (bbox[3]-bbox[1]) + line_spacing
        if current_height + lh > max_height:
            if current_chunk:
                chunks.append(current_chunk)
            current_chunk = [line]
            current_height = lh
        else:
            current_chunk.append(line)
            current_height += lh
    if current_chunk:
        chunks.append(current_chunk)
    return chunks

def text_to_hd_images(text_file, image_file_base, scale=1.0):
    img_width, img_height = 1920, 1080
    bg_color = (255, 255, 255)
    text_color = (0, 0, 0)
    base_outline = 1
    base_max_chars = 40
    base_line_spacing = 10

    margin_x = img_width // 5
    margin_y = img_height // 5

    # Text einlesen
    with open(text_file, 'r', encoding='utf-8') as f:
        text = f.read().strip()

    max_chars_per_line = int(base_max_chars * scale)
    wrapped_text = textwrap.fill(text, width=max_chars_per_line)
    all_lines = wrapped_text.split('\n')

    img = Image.new("RGB", (img_width, img_height), bg_color)
    draw = ImageDraw.Draw(img)

    font_path = find_system_font()
    font_size = 30
    if font_path:
        font = ImageFont.truetype(font_path, font_size)
    else:
        print("Warnung: Keine Systemfont gefunden, Fallback auf Default.")
        font = ImageFont.load_default()

    # Automatische Schriftgrößenanpassung
    while True:
        line_heights = [(draw.textbbox((0,0), line, font=font)[3]-draw.textbbox((0,0), line, font=font)[1]) + base_line_spacing for line in all_lines]
        total_height = sum(line_heights)
        max_line_width = max(draw.textbbox((0,0), line, font=font)[2]-draw.textbbox((0,0), line, font=font)[0] for line in all_lines)
        if total_height < (img_height - 2*margin_y) and max_line_width < (img_width - 2*margin_x):
            break
        font_size = max(1, font_size - 1)
        if font_path:
            font = ImageFont.truetype(font_path, font_size)
        else:
            font = ImageFont.load_default()
        if font_size == 1:
            break

    outline_radius = max(1, int(base_outline * scale))
    line_spacing = base_line_spacing

    # Text in Chunks aufteilen
    chunks = split_text_to_chunks(all_lines, draw, font, img_width-2*margin_x, img_height-2*margin_y, line_spacing)

    # Für jeden Chunk ein Bild erstellen
    for idx, chunk_lines in enumerate(chunks, start=1):
        img = Image.new("RGB", (img_width, img_height), bg_color)
        draw = ImageDraw.Draw(img)

        line_height = max(draw.textbbox((0,0), line, font=font)[3]-draw.textbbox((0,0), line, font=font)[1]+line_spacing for line in chunk_lines)
        total_text_height = line_height * len(chunk_lines)
        y_start = margin_y + ((img_height - 2*margin_y - total_text_height)//2)

        for i, line in enumerate(chunk_lines):
            bbox = draw.textbbox((0,0), line, font=font)
            text_width = bbox[2]-bbox[0]
            x = margin_x + ((img_width - 2*margin_x - text_width)//2)
            y = y_start + i*line_height

            # Outline dünn
            for dx in range(-outline_radius, outline_radius+1):
                for dy in range(-outline_radius, outline_radius+1):
                    if dx != 0 or dy != 0:
                        draw.text((x+dx, y+dy), line, font=font, fill='gray')
            draw.text((x, y), line, font=font, fill=text_color)

        # Bild speichern mit Nummerierung
        if len(chunks) == 1:
            output_file = image_file_base
        else:
            base, ext = os.path.splitext(image_file_base)
            output_file = f"{base}_{idx}{ext}"
        img.save(output_file)
        print(f"Bild erstellt: {output_file}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Verwendung: python3 txtToPicHD_multi.py textdatei.txt bilddatei.png [skalierungsfaktor]")
        sys.exit(1)

    text_file = sys.argv[1]
    image_file = sys.argv[2]
    scale = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
    text_to_hd_images(text_file, image_file, scale)

