from PIL import Image

def crop_image():
    # Load the horizontal hero image
    img = Image.open('4.jpg')
    width, height = img.size
    print(f"Original size: {width}x{height}")
    
    # We want a tighter vertical crop around the car
    # The car is centered horizontally, so we crop the sides to make it 4:5 or 3:4 aspect ratio
    # Let's crop to 3:4 aspect ratio (width = height * 0.75)
    new_width = int(height * 0.95) # slightly wider than height
    left = (width - new_width) // 2
    right = left + new_width
    top = 0
    bottom = height
    
    cropped = img.crop((left, top, right, bottom))
    cropped.save('4_mobile_crop.jpg', 'JPEG', quality=95)
    print(f"Saved cropped image to 4_mobile_crop.jpg with size: {cropped.size}")

if __name__ == '__main__':
    crop_image()
