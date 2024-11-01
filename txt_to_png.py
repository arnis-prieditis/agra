import cv2
import numpy as np

# Define a function to map symbols to colors
def symbol_to_color(symbol):
    color_map = {
        'R': (0, 0, 255),       # Red in BGR format
        'G': (0, 255, 0),       # Green
        'B': (255, 0, 0),       # Blue
        ' ': (0, 0, 0),         # Black
        '*': (255, 255, 255),   # White
        'Y': (0, 255, 255),     # Yellow
        'M': (255, 0, 255),     # Magenta
        'C': (255, 255, 0),     # Cyan

    }
    return color_map.get(symbol, (0, 0, 0))  # Default to black if symbol is unknown

def text_to_image(input_file, output_file):
    # Read the text file
    with open(input_file, 'r') as file:
        lines = file.readlines()

    # Determine image size
    height = len(lines)
    width = max(len(line) for line in lines)

    # Create a blank image (numpy array) with 3 channels (BGR) and set to black
    image = np.zeros((height, width, 3), dtype=np.uint8)

    # Set pixels based on the symbol in each position
    for y, line in enumerate(lines):
        for x, symbol in enumerate(line):
            image[y, x] = symbol_to_color(symbol)

    # Save the image
    cv2.imwrite(output_file, image)

# Example usage
input_file = 'pixel_art.txt'   # Replace with your text file path
output_file = 'output_image.png'  # You can use .jpg or .png as needed
text_to_image(input_file, output_file)
