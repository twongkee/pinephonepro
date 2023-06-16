"""
remove triangle dot pattern by averaging
"""
import numpy as np

raw = np.fromfile("frame.raw", np.uint8)


w = 4208
h = 3120

GRID_SPACING = 16
for fixy in range(0, 260):
    for fixx in range(0, 96):
        raw[w * (32 + fixx * GRID_SPACING * 2) + 25 + fixy * GRID_SPACING] = (
            int(raw[w * (32 + fixx * GRID_SPACING * 2) + 23 + fixy * GRID_SPACING])
            + int(raw[w * (32 + fixx * GRID_SPACING * 2) + 27 + fixy * GRID_SPACING])
            + int(raw[w * (30 + fixx * GRID_SPACING * 2) + 25 + fixy * GRID_SPACING])
            + int(raw[w * (34 + fixx * GRID_SPACING * 2) + 25 + fixy * GRID_SPACING])
        ) / 4
        raw[w * (29 + fixx * GRID_SPACING * 2) + 26 + fixy * GRID_SPACING] = (
            int(raw[w * (27 + fixx * GRID_SPACING * 2) + 26 + fixy * GRID_SPACING])
            + int(raw[w * (31 + fixx * GRID_SPACING * 2) + 26 + fixy * GRID_SPACING])
            + int(raw[w * (29 + fixx * GRID_SPACING * 2) + 24 + fixy * GRID_SPACING])
            + int(raw[w * (29 + fixx * GRID_SPACING * 2) + 28 + fixy * GRID_SPACING])
        ) / 4
        raw[w * (45 + fixx * GRID_SPACING * 2) + 34 + fixy * GRID_SPACING] = (
            int(raw[w * (47 + fixx * GRID_SPACING * 2) + 34 + fixy * GRID_SPACING])
            + int(raw[w * (43 + fixx * GRID_SPACING * 2) + 34 + fixy * GRID_SPACING])
            + int(raw[w * (45 + fixx * GRID_SPACING * 2) + 32 + fixy * GRID_SPACING])
            + int(raw[w * (45 + fixx * GRID_SPACING * 2) + 36 + fixy * GRID_SPACING])
        ) / 4
        raw[w * (48 + fixx * GRID_SPACING * 2) + 33 + fixy * GRID_SPACING] = (
            int(raw[w * (50 + fixx * GRID_SPACING * 2) + 33 + fixy * GRID_SPACING])
            + int(raw[w * (46 + fixx * GRID_SPACING * 2) + 33 + fixy * GRID_SPACING])
            + int(raw[w * (48 + fixx * GRID_SPACING * 2) + 31 + fixy * GRID_SPACING])
            + int(raw[w * (48 + fixx * GRID_SPACING * 2) + 35 + fixy * GRID_SPACING])
        ) / 4

raw.tofile("numpy.raw")
